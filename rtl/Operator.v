//操作中心
module Operator(
										input clk_1k,										//1kHz时钟
										input [3:0] num_in,						//键盘Keyboard>>，输入一个数，让操作中心判断需要进行什么操作
										input kb_en,										//键盘Keyboard>>，键盘使能，为了保证键盘扫描的稳定设置的，检测到上升沿后键盘的值成功输入到操作中心
										input [7:0] full,								//快递柜指示LD>>，指示快递柜目前是否被占用
										input rst,												//重置信号
										input closing,									//8×8点阵Screen>>，关门信号
										
										output reg [3:0] ds2=4'hA,			//>>七段数码管DISP，七段数码管2位显示的数字选择（注意！该值不一定让数码管显示对应的数字！只是一个选择信号，让DISP判断该显示什么！例如4'hA在DIPS的判断结果是不显示画面。其他详见DISP模块）
										output reg [3:0] ds1=4'hA,			//>>七段数码管DISP，七段数码管1位显示的数字选择
										output reg [3:0] ds0=4'hA,			//>>七段数码管DISP，七段数码管0位显示的数字选择
												
										output reg [3:0] taking=4'hA,			//>>快递柜指示LD，指示目前某个快递柜正在被取用，让LED闪烁
										output reg cfm=0,								//>>其他，表明键盘输入的三个数是有效的，指示其他器件进行打开柜门的操作
										output reg [3:0] snd_sel=4'hF,		//>>蜂鸣器BP，指示蜂鸣器目前应该播放的音乐
										output reg music=0								//>>蜂鸣器BP，操作蜂鸣器开始播放音乐
										);
	
	localparam DS_NONE=4'hA,
								DS_ERROR=4'hB,
								BP_NONE=4'hF,
								BP_COLSING=4'hB,
								BP_OPENING=4'hC,
								BP_ERROR=4'hE,
								BP_DELETE=4'hD,
								BP_ALLCLEAR=4'hA;
	
	
	//具体操作，检测到键盘使能上升沿后启动
		always@(posedge clk_1k or negedge rst or posedge closing)begin
			if(!rst) begin
				ds2<=DS_NONE;
				ds1<=DS_NONE;
				ds0<=DS_NONE;
				taking<=4'hA;
				cfm<=0;
				snd_sel<=BP_NONE;
				music<=0;
			end
			else if(closing)begin
				snd_sel<=BP_COLSING;
				music<=1;
			end
			else begin
				if(kb_en)begin
					case(num_in)
						4'hA:begin		//键盘传入这个值时，操作中心判断为按下了一个空键
										ds2<=ds2;
										ds1<=ds1;
										ds0<=ds0;
									end				
						4'hC:begin		//键盘传入这个值时，操作中心判断为按下了确认键	
										if({ds2,ds1,ds0}<8) begin	//仅有8个快递柜，且号码为000到007，所以只有这几个数据有效
											if(full[ds0]) begin	//对应的箱子里有快递，则判断传入数据成功
												ds2<=DS_NONE;			//数码管清空
												ds1<=DS_NONE;
												ds0<=DS_NONE;
												cfm<=1;					//发出确认信号，在代码末尾处else后会再次置零，逻辑上表明cfm是仅持续一个时钟周期的脉冲
												taking<=ds0;		//向快递柜指示LD模块指示目前取用的快递箱号
												snd_sel<=BP_OPENING;	//向蜂鸣器BP模块指示播放开门音乐
												music<=1;
											end
											else begin						//对应的箱子空，传入数据失败，显示E
												ds2<=DS_NONE;
												ds1<=DS_NONE;
												ds0<=DS_ERROR;				//此号码对应显示E字符，详见DISP模块
												snd_sel<=BP_ERROR;		//向蜂鸣器BP模块指示播放错误音乐
												music<=1;
											end
										end
										else begin												//输入的是一个无效号码，传入数据失败
											ds2<=DS_NONE;
											ds1<=DS_NONE;
											ds0<=DS_ERROR;		//此号码对应显示E字符，详见DISP模块
											snd_sel<=BP_ERROR;	//向蜂鸣器BP模块指示播放错误音乐
											music<=1;
										end
									end
						4'hD:begin	//键盘传入这个值时，操作中心判断进行删除操作，数据退一格
										ds2<=DS_NONE;
										ds1<=ds2;
										ds0<=ds1;
										snd_sel<=BP_DELETE;	//向蜂鸣器BP模块指示播放删除音乐
										music<=1;
									end
						4'hE:begin		//键盘传入这个值时，操作中心判断进行清空操作，数码管清空
										ds2<=DS_NONE;
										ds1<=DS_NONE;
										ds0<=DS_NONE;
										snd_sel<=BP_ALLCLEAR;//向蜂鸣器BP模块指示播放清空音乐
										music<=1;
									end
						default:begin	//键盘传入的其他值都判断为输入了一个数字，且输入三位后就停止输入
											if(ds0==DS_ERROR)begin					//显示E字符后输入，错误字符不占位，第0位数码管直接由E变为输入的数
												ds2<=DS_NONE;
												ds1<=DS_NONE;
												ds0<=num_in;
												snd_sel<=num_in;					//向蜂鸣器BP指示播放输入对应数字的音乐
												music<=1;
											end
											else if(ds2==DS_NONE)begin		//最高位空时才可以输入，保证输入的数字只有三位
												ds2<=ds1;
												ds1<=ds0;
												ds0<=num_in;
												snd_sel<=num_in;					//向蜂鸣器BP指示播放输入对应数字的音乐
												music<=1;
											end
										end
					endcase
				end
				else begin
					cfm<=0;		//确认信号在一个时钟周期后置零
					music<=0;
				end
			end
		end
	
endmodule
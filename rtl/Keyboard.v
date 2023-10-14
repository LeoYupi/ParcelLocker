//4×4键盘，列扫描
module Keyboard(
											input [3:0] kbrow_p,								//消抖后的键盘行信号
											input clk_1k,												//时钟
											input rst,														//计数器重置
											input playing,											//8×8点阵Screen>>，用于锁定键盘
										
											output reg [3:0] kbcol=4'b0000,	//列信号
											output reg [3:0]num_in,						//>>操作中心Operator，向操作中心输入一个值
											output reg kb_en=0								//键盘输入有效信号，检测到上升沿后才能让值进入操作中心，使用原因是键盘是动态扫描的，直接输出不稳定，使用使能信号保证稳定输出
										);
	
	reg [2:0] cnt=0;					//动态列扫描计数器
	reg [1:0] col_index=0;	//选中列标识，当检测到有效输入后对列进行标识，最后计算输出值时使用
	reg [1:0] row_index=0;	//选中行标识，当检测到有效输入后对行进行标识，最后计算输出值时使用
	reg col_ch=0;						//已标识到列信号，用该值控制键盘的输入是否有效

	//状态机
	always@(posedge clk_1k or negedge rst or posedge playing) begin
		if(!rst)begin
			cnt<=0;
			col_ch<=0;
			col_index<=0;
		end
		else if(playing) begin
			col_ch<=0;
			cnt<=0;
		end
		else begin
			case(cnt)
				3'd0:begin		//停止扫描状态
				col_ch<=0;				//标识到列信号置0，由于采用时钟上升沿扫描，该脉冲会持续一个时钟周期
								if(kbrow_p==4'b1111 && !playing)begin	//确认当前无按键按下，且8×8点阵Screen没有在播放动画时才进行扫描
								cnt<=cnt+1'b1;		//从第一列开始扫描
								kbcol<=4'b1110;	//提前准备好列信号
								end
							end
				3'd1:begin		//扫描第一列
								if(kbrow_p!=4'b1111)begin	//该列检测到按键按下
									col_index<=2'd0;								//标识该列，当前是0列
									col_ch<=1;											//列信号已标识完成
									cnt<=0;													//回到停止扫描状态
								end
								else begin						//该列没有检测到按键按下
									cnt<=cnt+1'b1;		//扫描下一列
									kbcol<=4'b1101;	//提前准备好列信号
								end	
							end
				3'd2:begin		//第二列有按键按下
								if(kbrow_p!=4'b1111)begin
									col_index<=2'd1;
									col_ch<=1;
									cnt<=0;
								end
								else begin
									cnt<=cnt+1'b1;
									kbcol<=4'b1011;
								end	
							end
				3'd3:begin		//第三列有按键按下
							if(kbrow_p!=4'b1111)begin
									col_index<=2'd2;
									col_ch<=1;
									cnt<=0;
								end
								else begin
									cnt<=cnt+1'b1;
									kbcol<=4'b0111;
								end
							end
				3'd4:begin		//第四列有按键按下
							if(kbrow_p!=4'b1111)begin
									col_index<=2'd3;
									col_ch<=1;
									cnt<=0;
								end
								else begin
									cnt<=3'd1;
									kbcol<=4'b1110;
								end
							end
				endcase
		end
	end
	
	//行信号标识
	always@(posedge clk_1k or negedge rst)begin
		if(!rst) begin
			row_index<=0;
		end
		else begin
			case(kbrow_p)
				4'b1110:row_index<=2'd3;
				4'b1101:row_index<=2'd2;
				4'b1011:row_index<=2'd1;
				4'b0111:row_index<=2'd0;
				default:row_index<=row_index;
			endcase
		end
	end
	
	//通过行列标识，指示键盘输出一个值，让操作中心判断进行什么操作
	always@(negedge clk_1k)begin
	//由于行列标识是多位，且在时钟上升沿改变的，若此处使用时钟上升沿检测，发现输出的信号为上一状态，所以使用时钟下降沿检测，当行列信号在上升沿改变完成并稳定后，延迟半个时钟周期判断输出值
		case({row_index,col_index})
				4'b1101:num_in<=4'h0;		//输入数字0
				4'b0000:num_in<=4'h1;		//输入数字1
				4'b0001:num_in<=4'h2;		//输入数字2
				4'b0010:num_in<=4'h3;		//输入数字3
				4'b0100:num_in<=4'h4;		//输入数字4
				4'b0101:num_in<=4'h5;		//输入数字5
				4'b0110:num_in<=4'h6;		//输入数字6
				4'b1000:num_in<=4'h7;		//输入数字7
				4'b1001:num_in<=4'h8;		//输入数字8
				4'b1010:num_in<=4'h9;		//输入数字9
				4'b0011:num_in<=4'hD;	//删除键Delete
				4'b0111:num_in<=4'hE;		//清空键Empty
				4'b1011:num_in<=4'hC;	//确认键Confirm
				default:num_in<=4'hA;		//空键
			endcase
		if(col_ch)begin	//检测到列信号被标识后发出键盘有效信号
			kb_en<=1;	//由于采用时间下降沿检测，该脉冲会持续一个时钟周期
		end
		else begin
			kb_en<=0;
		end
	end
	

	
endmodule
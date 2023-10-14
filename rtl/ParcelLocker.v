module ParcelLocker(
													input clk_in,					//系统时钟，默认为50MHz
													input rst,							//计数器重置
													input[3:0] kbrow,		//4×4键盘行信号
													//input [7:0] btn;		//独立按键
													
													output [3:0] kbcol,						//4×4键盘列信号
													output [7:0] row,r_col,g_col,	//8×8点阵行信号，红色r列信号，绿色g列信号
													output [7:0] ds_a,							//数码管段选端
													output [7:0] ds_cat,						//数码管位选端，仅用3个位
													output [7:0] led,								//快递柜指示LD
													output beep										//蜂鸣器
												);
	
	
	
	wire clk_1k,clk_2,clk_4;				//分频时钟，下划线后为对应频率
	wire [3:0] num_in;							//键盘Keyboard>>操作中心Operator，根据键盘的输入值进行不同的操作
	wire [3:0] ds2,ds1,ds0;				//操作中心Opera>>数码管，由操作中心控制数码管的显示值
	wire [3:0] kbrow_p;						//消抖后的4×4键盘行信号
//	wire [7:0] btndb;						//消抖后的独立按键
	wire kb_en;										//键盘Keyboard>>操作中心Operator，使能信号，检测到上升沿时操作中心才会进行操作
	wire cfm;											//操作中心Operator>>其他，确认信号，键盘输入的数字完成后点击确认，若成功则发出这个信号，使其他器件进行某些操作
	wire [3:0] taking;							//操作中心Operator>>快递柜指示LD，由操作中心向快递柜标识目前正在取用的快递柜号码
	wire playing;									//点阵Screen>>其他，正在播放指示，为1时表明点阵正在播放开关门动画
	wire [7:0] full;									//快递柜指示LD>>其他，为1时指示某个快递柜中存放了物品
	wire [3:0] snd_sel;							//操作中心Operator>>蜂鸣器BP，音乐选择信号，向蜂鸣器发送需要播放的音乐号码
	wire music;										//操作中心Operator>>蜂鸣器BP，音乐播放信号，是持续一个时钟周期的脉冲，接收到该信号后音乐开始播放
	wire closing;										//点阵Screen>>操作中心Operator，关门标记，接收到该信号后操作中心指示蜂鸣器播放关门音乐
	

	
//分频时钟=========================================
						ClockDivide Hz1k(										//1kHz的分频时钟
														.clk_in(clk_in),
														.frequency(1_000),
														.clk_div(clk_1k),
														.rst(rst)
														);
						ClockDivide Hz2(											//2Hz的分频时钟
														.clk_in(clk_in),
														.frequency(2),
														.clk_div(clk_2),
														.rst(rst)
														);
						ClockDivide Hz4(											//4Hz的分频时钟
														.clk_in(clk_in),
														.frequency(4),
														.clk_div(clk_4),
														.rst(rst)
									);	
	//=============================================								

	
	
	
	//8×8点阵=====================
			Screen scr(
									.clk_1k(clk_1k),
									.clk_4(clk_4),
									.row(row),
									.r_col(r_col),
									.g_col(g_col),
									.rst(rst),
									.cfm(cfm),
									.playing(playing),
									.closing(closing)
									);
//===========================
								
											
							
	//七段数码管DISP=========
		DISP DS(
					.a(ds_a),
					.cat(ds_cat),
					.clk_1k(clk_1k),
					.rst(rst),
					.ds2(ds2),
					.ds1(ds1),
					.ds0(ds0)
				);
	//==================
	
	
	
	//4×4矩阵键盘============
		Keyboard kb(
						.kbrow_p(kbrow_p),
						.kbcol(kbcol),
						.clk_1k(clk_1k),
						.rst(rst),
						.num_in(num_in),
						.kb_en(kb_en),
						.playing(playing)
						);
	//====================				
					
					
						
	//操作中心===============
		Operator op(
						.clk_1k(clk_1k),
						.num_in(num_in),
						.ds2(ds2),
						.ds1(ds1),
						.ds0(ds0),
						.kb_en(kb_en),
						.cfm(cfm),
						.taking(taking),
						.full(full),
						.snd_sel(snd_sel),
						.rst(rst),
						.music(music),
						.closing(closing)
						);
	//====================				
					
					
									
	//快递柜指示==============					
	LD ledld(
						.led(led),
						.clk_2(clk_2),
						.taking(taking),
						.playing(playing),
						.full(full),
						.rst(rst)
						);
	//====================					
						
						
										
	//独立按键===============									
/*	Button bu(	
				.btn_p(btndb),
				.num_in(num_in),
				.led(led),
				.clk_1k(clk_1k),
				.plus(plus)
				);*/	
	//====================			
				
			
		
	//蜂鸣器================
	BP bp(
					.clk_in(clk_in),
					.clk_1k(clk_1k),
					.beep(beep),
					.snd_sel(snd_sel),
					.music(music),
					.rst(rst)
					);
	//====================
				
				
					
	//按键消抖===============			
		debounce kbdb0(
						.clk(clk_in),
						.nrst(rst),
						.key_in(kbrow[0]),
						.key_out(kbrow_p[0])
						);
		debounce kbdb1(
						.clk(clk_in),
						.nrst(rst),
						.key_in(kbrow[1]),
						.key_out(kbrow_p[1])
						);
		debounce kbdb2(
						.clk(clk_in),
						.nrst(rst),
						.key_in(kbrow[2]),
						.key_out(kbrow_p[2])
						);
		debounce kbdb3(
						.clk(clk_in),
						.nrst(rst),
						.key_in(kbrow[3]),
						.key_out(kbrow_p[3])
						);						
	/*	debounce db0(
						.clk(clk_in),
						.nrst(1),
						.key_in(btn[0]),
						.key_out(btndb[0])
						);
		debounce db1(
						.clk(clk_in),
						.nrst(1),
						.key_in(btn[1]),
						.key_out(btndb[1])
						);
		debounce db2(
						.clk(clk_in),
						.nrst(1),
						.key_in(btn[2]),
						.key_out(btndb[2])
						);
		debounce db3(
						.clk(clk_in),
						.nrst(1),
						.key_in(btn[3]),
						.key_out(btndb[3])
						);
		debounce db4(
						.clk(clk_in),
						.nrst(1),
						.key_in(btn[4]),
						.key_out(btndb[4])
						);
		debounce db5(
						.clk(clk_in),
						.nrst(1),
						.key_in(btn[5]),
						.key_out(btndb[5])
						);
		debounce db6(
						.clk(clk_in),
						.nrst(1),
						.key_in(btn[6]),
						.key_out(btndb[6])
						);
		debounce db7(
						.clk(clk_in),
						.nrst(1),
						.key_in(btn[7]),
						.key_out(btndb[7])
						);					
		*/
//======================	
	
	

endmodule
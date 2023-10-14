//七段数码管
module DISP(
								input clk_1k, 									//时钟
								input rst,												//计数器重置
								input [3:0] ds2,ds1,ds0,//分别选择数码管2、1、0位需要显示的数字
								
								output reg [7:0] a=0,					//数码管段码A~G，最后一位小数点
								output reg [7:0] cat=0				//数码管位选，其实只用3位，但只写三位别的会亮
								);
	
	reg [7:0] seg [11:0];		//设置数组，存储不同数字需要打开的数码管段
	reg [1:0] cnt_cat = 0; 	//位选端的动态扫描计数器
	reg seg_write=1;			//初始化seg数组的开关，seg数组只写一次，写完就置零
	
	localparam   NUM0=4'h0,
								NUM1=4'h1,
								NUM2=4'h2,
								NUM3=4'h3,
								NUM4=4'h4,
								NUM5=4'h5,
								NUM6=4'h6,
								NUM7=4'h7,
								NUM8=4'h8,
								NUM9=4'h9,
								NONE=4'hA,
								ERROR=4'hB;
	
	//初始化seg数组
	always@(posedge clk_1k) begin
		if(seg_write) begin	
			seg[NUM0] <= 8'b00111111;	//显示0
			seg[NUM1] <= 8'b00000110;	//显示1
			seg[NUM2] <= 8'b01011011;	//显示2
			seg[NUM3] <= 8'b01001111;	//显示3			 
			seg[NUM4] <= 8'b01100110;	//显示4
			seg[NUM5] <= 8'b01101101;	//显示5
			seg[NUM6] <= 8'b01111101;	//显示6
			seg[NUM7] <= 8'b00000111;	//显示7
			seg[NUM8] <= 8'b01111111;	//显示8
			seg[NUM9] <= 8'b01101111;	//显示9
			seg[NONE]  <= 8'b00000000;	//显示空
			seg[ERROR] <= 8'b01111001;	//显示E
			seg_write<=0;								//seg初始化完毕，该信号置零
		end
	end
	
	//数码管扫描计数器控制
   always @(posedge clk_1k or negedge rst)
		 begin
			if(!rst)													//重置信号到来直接置到一个不会亮屏的值
				 cnt_cat <= 2'b11;
			else if(cnt_cat ==2'b10)			//只用三段数码管，到3就变回0
				 cnt_cat <= 2'b00;
			else														//正常计数
				 cnt_cat <= cnt_cat + 1'b1;
		 end  
		 
		 // 数码管位选动态扫描
	   always @(posedge clk_1k) 
		begin
			case(cnt_cat)
				 2'b00:begin cat <= 8'b11111110; a <=  seg[ds0]; end//0位
				 2'b01:begin cat <= 8'b11111101; a <=  seg[ds1]; end//1位
				 2'b10:begin cat <= 8'b11111011; a <=  seg[ds2]; end//2位
				 default:begin cat<=0;a<=0; end
			endcase
		end
		
endmodule
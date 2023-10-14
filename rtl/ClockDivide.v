//时钟分频
module ClockDivide(
												input clk_in,							//系统时钟
												input rst,									//计数器重置信号
												input [25:0] frequency,	//分频后的时钟频率，例化时直接输入一个数字就可以，为保证50MHz能分频成1Hz，需要26位
												
												output reg clk_div=0		//分频后的时钟
											);
	 
	 parameter SYS_FREQUENCY=26'd50_000_000;	//设置系统时钟的频率，默认为50MHz，该值可在例化时修改
	 
	 reg [24:0] cnt=0;															//25位计数器，最小能将50MHz分成1Hz
	 
	 //计数器控制
	 always @(posedge clk_in or negedge rst)
			begin
				if(!rst)begin																					//重置信号到来时直接置零
					cnt<=0;
				end
				else if(cnt == (SYS_FREQUENCY/2/frequency-1))	//该计算公式可以保证分频后时钟频率与input的frequency值相等
					  begin
						  cnt <= 0;
						  clk_div <= ~clk_div;
				end
				else 																									//正常计数
					  cnt <= cnt+1'b1;
			end
	 
endmodule
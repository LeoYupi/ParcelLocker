//快递柜指示
module LD(
							input clk_2,									//时钟
							input [3:0] taking,						//操作中心Operator>>，表明某个快递柜正在被打开，该值最初是大于快递柜号0到7的，所以以下always块不会进行任何操作
							input playing,								//8×8点阵Screen>>，表明当前正在播放动画
							input rst,											//重置信号，让快递柜回到全部被占用的状态
							
							output reg [7:0] led=8'hFF,	//快递柜的LED灯光
							output reg [7:0] full=8'hFF	//快递柜是否被占用，为1表示快递柜有东西
							);

	//LED灯开关控制
	always @(posedge clk_2 or negedge rst or negedge playing)
		  begin  
				if(!rst) begin
					full<=8'hFF;
					led<=8'hFF;
				end
				else if(!playing) begin//动画未在播放
					full[taking]<=0; 		//表明快递柜已空
					led[taking]<=0;			//led熄灭
				end
				else														//动画正在播放		
					led[taking]<=~led[taking];	//LED按时钟频率闪烁
		  end	
	
endmodule
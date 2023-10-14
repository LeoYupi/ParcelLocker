`timescale 10us/1ns
module ClockDivide_tb;
    reg clk_in;
    wire clk_div01;
	 wire clk_div02;
	 wire beep;
	 
	 
	 ClockDivide testbench01(
	 .clk_in(clk_in),
    .frequency(1_000),
	 .clk_div(clk_div01),
    .rst(0)
	 );
	 
	 ClockDivide testbenc02(
	 .clk_in(clk_in),
    .frequency(2),
	 .clk_div(clk_div02),
    .rst(0)
	 );
	
	BP bp(
			.clk_in(clk_in),
			.clk_2(clk_div02),
			.beep(beep),
			.snd_sel(0)
			);
			
			
			
parameter clk_period = 10;  
initial  begin
    clk_in = 0;
		end
always #(clk_period/2) clk_in = ~clk_in;  
endmodule
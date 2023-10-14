`timescale 100ns/1ns
module ParcelLocker_tb;
    reg clk_in;
    wire [7:0] row;
    wire [7:0] r_col;
	 wire [7:0] g_col;

	 ParcelLocker testbench(
	 .clk_in(clk_in),
	 .row(row),
    .r_col(r_col),
    .g_col(g_col),
	 .rst(0)
	 );
	
  
parameter clk_period = 10;  
initial  begin
    clk_in = 0;
		#35000000;
		$stop;
		end
always #(clk_period/2) clk_in = ~clk_in;  
endmodule
module Button(btn_p,num_in,led,clk_1k,plus);
	input [7:0] btn_p;
	input clk_1k;
	output reg [3:0] num_in;
	output reg [7:0] led=8'b0000_0000;
	output reg plus=0;
	
	always@(posedge clk_1k) begin
		case(btn_p)
			8'b0000_0000:begin num_in<=num_in;led<=8'b0000_0000;plus<=0;end
			8'b0000_0001:begin num_in<=3'b000;led<=8'b0000_0001;plus<=1;end
			8'b0000_0010:begin num_in<=3'b001;led<=8'b0000_0010;plus<=1;end
			8'b0000_0100:begin num_in<=3'b010;led<=8'b0000_0100;plus<=1;end
			8'b0000_1000:begin num_in<=3'b011;led<=8'b0000_1000;plus<=1;end
			8'b0001_0000:begin num_in<=3'b100;led<=8'b0001_0000;plus<=1;end
			8'b0010_0000:begin num_in<=3'b101;led<=8'b0010_0000;plus<=1;end
			8'b0100_0000:begin num_in<=3'b110;led<=8'b0100_0000;plus<=1;end
			8'b1000_0000:begin num_in<=3'b111;led<=8'b1000_0000;plus<=1;end
			default:begin num_in<=num_in;led<=8'b0000_0000;plus<=0;end
	endcase
	end
endmodule
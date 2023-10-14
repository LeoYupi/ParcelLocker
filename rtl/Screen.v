//8×8点阵，行扫描
module Screen(
									input clk_1k,clk_4,						//时钟
									input rst,											//计数器重置
									input cfm,										//确认信号，操作中心Operator>>，接到后播放动画
								
									output reg[7:0] row=0,			//行信号，低电平有效
									output reg[7:0] r_col=0,		//红列信号，高电平有效
									output reg[7:0] g_col=0,		//绿列信号，高电平有效
									output reg  playing=0,			//正在播放动画指示，用于锁定键盘等操作
									output reg closing=0
									);
	 
	 
	 reg [4:0] cnt_playing= 0;						//图案切换计数器
	 reg [2:0] cnt_scan= 0;							//动态扫描计数器
	 
	 
	 //图案切换计数
	 always @(posedge clk_4 or negedge rst or posedge cfm)
		  begin  
				if(!rst) begin
					cnt_playing<=0;
					playing<=0;
				end
				else if(cfm)begin												//接到cfm信号，计数器由0变为1，后正常计数，正在播放指示打开
					cnt_playing<=5'b00001;
					playing<=1;
				end
				else if(cnt_playing==5'b11110) begin	//计数器到该点后回到0，关闭正在播放指示
					cnt_playing<=0;
					playing<=0;
				end
				else if(cnt_playing==0)
					cnt_playing<=cnt_playing;						//计数器为0时若没有外部触发，则不会播放
				else begin																//正常计数
					cnt_playing<=cnt_playing+1'b1;
					playing<=playing;
				end
		  end	
		
	 //动态扫描计数器
    always @(posedge clk_1k or negedge rst)
	     begin
				if(!rst)begin												//接到rst信号，将计数器置零
					cnt_scan<=0;
				end
				else if(cnt_playing==0)						//此时播放停止，为安全考虑，将动态扫描计数器也停止
						cnt_scan<=cnt_scan;
			   else if(cnt_scan ==3'b111)				//此时8行的动态扫描已经完成了1次，将置零再次扫描
					 cnt_scan <= 3'b000;
				else																//正常计数
					 cnt_scan <= cnt_scan + 1'b1;
		  end
		  
		 //动态扫描控制 
		always @(posedge clk_1k)begin
		 case(cnt_scan)
		 3'b111:row<=8'b0111_1111; 
		 3'b110:row<=8'b1011_1111; 
		 3'b101:row<=8'b1101_1111; 
		 3'b100:row<=8'b1110_1111; 
		 3'b011:row<=8'b1111_0111; 
		 3'b010:row<=8'b1111_1011; 
		 3'b001:row<=8'b1111_1101; 
		 3'b000:row<=8'b1111_1110; 
		 default:row<=0; 
		 endcase
		end
		
   
	//图案切换控制=====================================================
	  always @(negedge rst or posedge clk_1k)
			begin
			  if(!rst) begin
				r_col<=0;
				g_col<=0;
				end
				else begin
			  case(cnt_playing)
			  
					//开门，一拍一个图案，与关门时区别，中心会有一个黄色的方块表示包裹在里面=====
				 	5'b00000:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b011:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b010:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end
				 	5'b00001:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b1110_0111; g_col<= 8'b0001_1000; end
							 3'b101:begin  r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b100:begin  r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b011:begin  r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b010:begin  r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b001:begin  r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b000:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end
					5'b00010:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b1110_0111; g_col<= 8'b0001_1000; end
							 3'b101:begin  r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b100:begin  r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b011:begin  r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b010:begin  r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b001:begin  r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b000:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end
				 	5'b00011:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b1111_1011; g_col<= 8'b0000_0100; end
							 3'b101:begin  r_col<=8'b1111_1011; g_col<= 8'b0000_0100; end
							 3'b100:begin  r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b011:begin  r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b010:begin  r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b001:begin  r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b000:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end
					5'b00100:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b1111_1001; g_col<= 8'b0000_0110; end
							 3'b101:begin  r_col<=8'b1111_1010; g_col<= 8'b0000_0101; end
							 3'b100:begin  r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b011:begin  r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b010:begin  r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b001:begin  r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b000:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end											 
				 	5'b00101:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b011:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b010:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end	
					5'b00110:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_1111; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b011:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b010:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_1111; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end
				 	5'b00111:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_0011; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b0000_1111; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b0011_1111; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b0011_1111; g_col<= 8'b0000_0000; end
							 3'b011:begin  r_col<=8'b0011_1111; g_col<= 8'b0000_0000; end
							 3'b010:begin  r_col<=8'b0011_1111; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b0000_1111; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_0011; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end				 
				 	5'b01000:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_0001; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b0000_0111; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b0000_1111; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b0001_1111; g_col<= 8'b0001_0000; end
							 3'b011:begin  r_col<=8'b0001_1111; g_col<= 8'b0001_0000; end
							 3'b010:begin  r_col<=8'b0000_1111; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b0000_0111; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_0001; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end
					5'b01001:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_0001; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b0000_0011; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b0000_0111; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b0001_1111; g_col<= 8'b0001_1000; end
							 3'b011:begin  r_col<=8'b0001_1111; g_col<= 8'b0001_1000; end
							 3'b010:begin  r_col<=8'b0000_0111; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b0000_0011; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_0001; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end		
					
					
					//柜门完全打开，以下空几拍保证3秒后柜门才关闭，中心黄色包裹图案显示2秒=====	
				 	5'b01010:begin																															
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b011:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b010:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end				 
				 5'b01011:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b011:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b010:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end
				 5'b01100:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b011:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b010:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end							
				 5'b01101:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b011:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b010:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end
				5'b01110:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b011:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b010:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end
				5'b01111:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b011:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b010:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end
				5'b10000:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b011:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b010:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end
				5'b10001:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b011:begin  r_col<=8'b0001_1000; g_col<= 8'b0001_1000; end
							 3'b010:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end
				 
				 //包裹消失，再过一秒关柜门，此时屏幕不亮，default已包含该情况=========
				 							

				 //关门，一拍一个图案====================================
				 5'b10110:begin
							 closing<=1;
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_0001; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b0000_0011; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b0000_0111; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b0000_0111; g_col<= 8'b0000_0000; end
							 3'b011:begin  r_col<=8'b0000_0111; g_col<= 8'b0000_0000; end
							 3'b010:begin  r_col<=8'b0000_0111; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b0000_0011; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_0001; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
						 end
				 5'b10111:begin
							closing<=0;
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_0001; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b0000_0111; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b0000_1111; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b0001_1111; g_col<= 8'b0001_0000; end
							 3'b011:begin  r_col<=8'b0001_1111; g_col<= 8'b0001_0000; end
							 3'b010:begin  r_col<=8'b0000_1111; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b0000_0111; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_0001; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end
				 5'b11000:begin
							 case(cnt_scan)
							 3'b111:begin r_col<=8'b0000_0011; g_col<= 8'b0000_0000; end
							 3'b110:begin r_col<=8'b0000_1111; g_col<= 8'b0000_0000; end
							 3'b101:begin r_col<=8'b0011_1111; g_col<= 8'b0000_0000; end
							 3'b100:begin r_col<=8'b0011_1111; g_col<= 8'b0000_0000; end
							 3'b011:begin r_col<=8'b0011_1111; g_col<= 8'b0000_0000; end
							 3'b010:begin r_col<=8'b0011_1111; g_col<= 8'b0000_0000; end
							 3'b001:begin r_col<=8'b0000_1111; g_col<= 8'b0000_0000; end
							 3'b000:begin r_col<=8'b0000_0011; g_col<= 8'b0000_0000; end
							 default:begin r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
						 end
				5'b11001:begin
							 case(cnt_scan)
							 3'b111:begin  r_col<=8'b0000_1111; g_col<= 8'b0000_0000; end
							 3'b110:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b101:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b100:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b011:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b010:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b001:begin  r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b000:begin  r_col<=8'b0000_1111; g_col<= 8'b0000_0000; end
							 default:begin  r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
							end
				5'b11010:begin
							 case(cnt_scan)
							 3'b111:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b110:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b101:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b100:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b011:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b010:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b001:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b000:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 default:begin r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
						 end
				5'b11011:begin
							 case(cnt_scan)
							 3'b111:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b110:begin r_col<=8'b1111_1001; g_col<= 8'b0000_0110; end
							 3'b101:begin r_col<=8'b1111_1010; g_col<= 8'b0000_0101; end
							 3'b100:begin r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b011:begin r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b010:begin r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b001:begin r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b000:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 default:begin r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
						 end
				5'b11100:begin
							 case(cnt_scan)
							 3'b111:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b110:begin r_col<=8'b1111_1011; g_col<= 8'b0000_0100; end
							 3'b101:begin r_col<=8'b1111_1011; g_col<= 8'b0000_0100; end
							 3'b100:begin r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b011:begin r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b010:begin r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b001:begin r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b000:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 default:begin r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
						 end
				5'b11101:begin
							 case(cnt_scan)
							 3'b111:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b110:begin r_col<=8'b1110_0111; g_col<= 8'b0001_1000; end
							 3'b101:begin r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b100:begin r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b011:begin r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b010:begin r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b001:begin r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b000:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 default:begin r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
						 end
				5'b11110:begin
							 case(cnt_scan)
							 3'b111:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 3'b110:begin r_col<=8'b1110_0111; g_col<= 8'b0001_1000; end
							 3'b101:begin r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b100:begin r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b011:begin r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b010:begin r_col<=8'b1101_1011; g_col<= 8'b0010_0100; end
							 3'b001:begin r_col<=8'b1100_0011; g_col<= 8'b0011_1100; end
							 3'b000:begin r_col<=8'b1111_1111; g_col<= 8'b0000_0000; end
							 default:begin r_col<=8'b0000_0000; g_col<= 8'b0000_0000; end
							 endcase
						 end
				
				//关门完成，计数器回到零停止，点阵全部熄灭========================

				
				//出现任何意外状况都保证点阵全部熄灭============================
				default:begin r_col<=0; g_col<= 0; end
				
				endcase
				end
			end              
	 //图案切换控制结束==================================================
	 
	 
	 
	endmodule

//蜂鸣器
module BP(
							input clk_in,clk_1k,				//时钟信号
							input [3:0] snd_sel,				//操作中心Operator>>，音乐选择信号，播放某一段音乐
							input music,								//操作中心Operator>>，音乐播放信号
							input rst,										//重置信号
	
							output reg beep=1				//蜂鸣器电平，按一定频率高低电平切换时会发出响声
						);
	
	reg [17:0] note_pitch;				//当前音符的音高
	reg [8:0] note_duration=0;	//当前音符的时值，灵敏度1ms
	reg [3:0] cnt_note=0;				//音符切换计数器，+1后播放下一个音符
	reg [17:0] cnt_pitch=0;			//音高计数器，计数器置零时该周期结束，beep由低电平变为高电平
	reg [17:0] cnt_tone=0;				//占空比调节计数器，计数器置零时beep由高电平变为低电平
	reg [8:0] cnt_duration=0;		//时值计数器，控制某个音响多久
	
	localparam   c1_PITCH=18'd190839,			//不同音符对音高计数器的置零时的取值要求，控制着该音高的周期长度
								d1_PITCH=18'd170068,
								e1_PITCH=18'd151515,			//音符表示方法示例：c1为小字一组的do，即中央C
								f1_PITCH=18'd143266,
								g1_PITCH=18'd127511,
								a1_PITCH=18'd113636,
								b1_PITCH=18'd101215,
								c2_PITCH=18'd95602,
								d2_PITCH=18'd85179,
								e2_PITCH=18'd75873,
								f2_PITCH=18'd71633,
								g2_PITCH=18'd63776,
								a2_PITCH=18'd56818,
								b2_PITCH=18'd50607;
								
	parameter DIVIDE=2;		//用音高计数器，即周期除这个数，再响应调节占空比计数器，可以调节占空比，为2的时候占空比50%

	//占空比计数器的计算
	always@(posedge clk_in or negedge rst) begin
		if(!rst)
			cnt_tone<=0;
		else if(cnt_tone==note_pitch/DIVIDE-1 || cnt_pitch==note_pitch-1)	//置零的两种条件：1、高电平结束；2、周期结束
			cnt_tone<=0;
		else cnt_tone<=cnt_tone+1'b1;																		//正常计数
	end
	
	//音高计数器的计算
	always@(posedge clk_in or negedge rst) begin
		if(!rst)
			cnt_pitch<=0;
		else if(cnt_pitch==note_pitch-1)		//置零条件：周期结束
			cnt_pitch<=0;
		else															//正常计数
			cnt_pitch<=cnt_pitch+1'b1;
	end
	
	//蜂鸣器电平的切换
	always@(posedge clk_in) begin
		if(note_pitch==0)
			beep<=1;
		else begin
			if(cnt_tone==0 && beep==1)					//占空比计数器结束，beep为1>>0
				beep<=0;
			else if(cnt_pitch==0 && beep ==0)		//音高计数器结束，beep为0>>1
				beep<=1;
				else beep<=beep;										//其余情况不变
		end
	end
	
	//音符计数器的计算..............................................待完善
	always@(posedge clk_1k or posedge music or negedge rst)begin
		if(!rst)
			cnt_note<=0;
		else if(music)
			cnt_note<=4'b0001;
		else if(note_duration==9'b1_1111_1111)
			cnt_note<=0;
		else if(cnt_duration==note_duration)
			cnt_note<=cnt_note+1'b1;
	end
	
	always@(posedge clk_1k or negedge rst or posedge music)begin
		if(!rst)
			cnt_duration<=0;
		else if(music)
			cnt_duration<=0;
		else if(cnt_duration==note_duration)
			cnt_duration<=0;
		else if(note_duration==9'b1_1111_1111)
			cnt_duration<=cnt_duration;
		else cnt_duration<=cnt_duration+1'b1;
	end
	
	//判断声音选择和音符加减，播放音乐
	always@(posedge clk_in)begin
		case(snd_sel)
			4'h0:case(cnt_note)															//0到9为按下相应数字按键的音乐
							4'b0001:begin note_pitch<=e2_PITCH;	note_duration<=9'd125;end
							default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
						endcase
			4'h1:case(cnt_note)
							4'b0001:begin note_pitch<=c1_PITCH;	note_duration<=9'd125;end
							default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
						endcase
			4'h2:case(cnt_note)
							4'b0001:begin note_pitch<=d1_PITCH;	note_duration<=9'd125;end
							default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
						endcase
			4'h3:case(cnt_note)
							4'b0001:begin note_pitch<=e1_PITCH;	note_duration<=9'd125;end
							default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
						endcase
			4'h4:case(cnt_note)
							4'b0001:begin note_pitch<=f1_PITCH;	note_duration<=9'd125;end
							default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
						endcase
			4'h5:case(cnt_note)
							4'b0001:begin note_pitch<=g1_PITCH;	note_duration<=9'd125;end
							default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
						endcase
			4'h6:case(cnt_note)
							4'b0001:begin note_pitch<=a1_PITCH;	note_duration<=9'd125;end
							default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
						endcase
			4'h7:case(cnt_note)
							4'b0001:begin note_pitch<=b1_PITCH;	note_duration<=9'd125;end
							default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
						endcase
			4'h8:case(cnt_note)
							4'b0001:begin note_pitch<=c2_PITCH;	note_duration<=9'd125;end
							default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
						endcase
			4'h9:case(cnt_note)
							4'b0001:begin note_pitch<=d2_PITCH;	note_duration<=9'd125;end
							default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
						endcase
			4'hA:case(cnt_note)															//清空（All）音乐
							4'b0001:begin note_pitch<=g1_PITCH;	note_duration<=9'd125;end
							4'b0010:begin note_pitch<=a1_PITCH;	note_duration<=9'd125;end
							4'b0011:begin note_pitch<=f1_PITCH;	note_duration<=9'd125;end
							default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
						endcase
			4'hB:case(cnt_note)//关门
							4'b0001:begin note_pitch<=c2_PITCH;	note_duration<=9'd125;end
							4'b0010:begin note_pitch<=b1_PITCH;	note_duration<=9'd125;end
							4'b0011:begin note_pitch<=a1_PITCH;	note_duration<=9'd125;end
							4'b0100:begin note_pitch<=g1_PITCH;	note_duration<=9'd125;end
							4'b0101:begin note_pitch<=f1_PITCH;	note_duration<=9'd125;end
							4'b0110:begin note_pitch<=e1_PITCH;	note_duration<=9'd125;end
							4'b0111:begin note_pitch<=d1_PITCH;	note_duration<=9'd125;end
							4'b1000:begin note_pitch<=c1_PITCH;	note_duration<=9'd250;end
							default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
						endcase
			4'hC:case(cnt_note)															//确认（Comfirm，开门）音乐
							4'b0001:begin note_pitch<=c1_PITCH;	note_duration<=9'd375;end
							4'b0010:begin note_pitch<=e1_PITCH;	note_duration<=9'd125;end
							4'b0011:begin note_pitch<=g1_PITCH;	note_duration<=9'd125;end
							4'b0100:begin note_pitch<=0				;	note_duration<=9'd125;end
							4'b0101:begin note_pitch<=c2_PITCH;	note_duration<=9'd125;end
							default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
						endcase
			4'hD:	case(cnt_note)														//删除（Delete）音乐
							4'b0001:begin note_pitch<=a2_PITCH;	note_duration<=9'd125;end
							4'b0010:begin note_pitch<=f2_PITCH;	note_duration<=9'd125;end
							default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
						endcase
			4'hE:	case(cnt_note)														//错误（Error，显示E字符）音乐
							4'b0001:begin note_pitch<=g1_PITCH;	note_duration<=9'd125;end
							4'b0010:begin note_pitch<=g1_PITCH;	note_duration<=9'd125;end
							default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
						endcase
			default:begin note_pitch<=0;note_duration<=9'b1_1111_1111;end
		endcase
	end
	
endmodule
	
	
	
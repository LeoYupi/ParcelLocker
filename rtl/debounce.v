module debounce(clk, nrst,key_in,key_out);
	 input clk, nrst;
    input key_in;
    output reg key_out;
	 

    localparam TIME_20MS = 1_000_000; 

    //变量
    reg [20:0] cnt=0;
    reg key_cnt=0;
    
    // 消抖时间结束后检查按键值
    always @(posedge clk or negedge nrst) begin
        if(nrst == 0)
            key_out <= 0;
        //在20ms结束，才将key_in赋值给key_out
        else if(cnt == TIME_20MS - 1)
            key_out <= key_in;
    end

    //消抖状态时计数，否则为0
    always @(posedge clk or negedge nrst) begin
        if(nrst == 0)
            cnt <= 0;
        else if(key_cnt)
            cnt <= cnt + 1'b1;
        else
            cnt <= 0; 
    end
     
     always @(posedge clk or negedge nrst) begin
            if(nrst == 0)
                key_cnt <= 0;
            else if(key_cnt == 0 && key_in != key_out)
                key_cnt <= 1;
            else if(cnt == TIME_20MS - 1)
                key_cnt <= 0;
     end
endmodule
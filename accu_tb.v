module accu_tb ();

reg clk, resetn, wr_en, rd;
reg [4:-5] data_in;
wire [31:0] scaled;
wire [23:0] data_out;
reg [8:0]  wptr,rptr;
reg [31:0] count;
wire read_out;
wire write_done;


accumulator acc ( .clk(clk), .resetn(resetn),.write_done(write_done) ,.wr_en(wr_en), .rd(rd), .data_in(data_in), .data_out(data_out), .outbyte(read_out) ,.rptr(rptr),.wptr(wptr));

initial 
begin
    clk = 0;#5;
    forever begin
        clk = ~clk;#5;
    end
end

initial
begin
    resetn = 1;#5;
    resetn = 0;#10;
    resetn = 1;#5;
    data_in = 227;wr_en =1; #10;wr_en = 0;#5 
    data_in = 51;wr_en =1; #10;wr_en = 0;#5
    data_in = 243;wr_en =1; #10;wr_en = 0;#5
    data_in = 0'h56;#10;
    data_in = 227;wr_en =1; #10;wr_en = 0;#5
    data_in = 51;wr_en =1; #10;wr_en = 0;#5
    data_in = 243;wr_en =1; #10;wr_en = 0;#5 
    data_in = 0'h56;#10;
    data_in = 7'b0_111_001;#5
    $display ("%f", data_in);
    data_in = 13.112 * 2048;wr_en =1; #10;wr_en = 0;#5
    $display ("%f", data_in/2048.0);
    // $display ("%f", scaled);

end

always @(posedge clk) begin
    if (~resetn)
    begin
        count <= 0;
        wptr<= 0;
        rptr <=0;
    end
    else begin
    if (wr_en)
    begin
        rd <= 0;
        if (write_done) wptr <= wptr +1;
        else wptr <= wptr;    end    
    else
    begin
        rd <= 1;    
        if (read_out)
        begin
            rptr <= rptr+1;
            count <= count +1;
        end   
    end
    end
end


endmodule

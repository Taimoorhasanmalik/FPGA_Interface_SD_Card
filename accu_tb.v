module accu_tb ();

reg clk, resetn, wr_en, rd;
reg [7:0] data_in;
wire [23:0] data_out;
reg [1:0] channel;

accumulator dut(.clk(clk),.resetn(resetn),.wr_en(wr_en),.rd(rd),.data_in(data_in),.data_out(data_out),.outbyte(outbyte));

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
    data_in = 0'h34;wr_en =1; #10;wr_en = 0;#5 
    data_in = 0'h12;wr_en =1; #10;wr_en = 0;#5
    data_in = 0'h56;wr_en =1; #10;wr_en = 0;#5
    data_in = 0'h56;#10;
    data_in = 0'h12;wr_en =1; #10;wr_en = 0;#5
    data_in = 0'h56;wr_en =1; #10;wr_en = 0;#5
    data_in = 0'h34;wr_en =1; #10;wr_en = 0;#5 
    data_in = 0'h56;#10;

    rd = 1;#30



    $stop;

end


endmodule

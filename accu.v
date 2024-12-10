module accumulator #(parameter DATA_WIDTH = 24,
                    parameter SIZE = 9

) (
                    input wire clk, resetn, wr_en, rd, 
                    input wire [7:0] data_in,
                    output reg [23:0] data_out = 0,
                    output reg outbyte = 0);


    reg [DATA_WIDTH-1:0] bram [0:(2<<SIZE-1)-1];
    reg [SIZE-1:0] wptr, rptr;
    reg [7:0] byte1,byte2,byte3;
    wire [23:0] final;
    reg [2:0] count;
    reg ready;
    wire [11:0] sample1,sample2;
    assign sample1 = {byte2[3:0], byte3};                     // First 12-bit sample
    assign sample2 = {byte1, byte2[7:4]};                    // Second 12-bit sample
    assign final = {sample2, sample1};
    always @(posedge clk) begin
        if (~resetn)
        begin
            wptr <= 0;
            rptr <= 0;
            byte1 <= 0;
            byte2 <= 0;
            byte3 <= 0;
            count <= 0;
            ready <= 0;
        end
        else begin
            if (wr_en) begin
                byte1 <= data_in;
                byte2 <= byte1;
                byte3 <= byte2;
                count <= count +1;
            end
            else begin
                if (rd) begin
                    if (wptr <= rptr)
                    begin
                        rptr <= rptr -2;
                        outbyte <= 0;
                    end
                    else begin
                data_out <= bram[rptr];
                rptr <= rptr+1;
                outbyte <= 1;
                    end
            end 
                else
                begin
                    outbyte <= 0;
                end

            end
            if (count == 3)
                begin
                    bram [wptr] <= final;
                    wptr <= wptr +1;
                    count <= 0;
                end            
        end
    end
endmodule
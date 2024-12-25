module accumulator #(parameter DATA_WIDTH = 24,
                    parameter SIZE = 9,
                    parameter SCALE = 200.0,
                    parameter ADC_OFFSET = 1024

) (
                    input wire clk, resetn, wr_en, rd, 
                    input wire [SIZE-1:0]  wptr,rptr,
                    input wire [4:-5] data_in,
                    output reg [23:0] data_out = 0,
                    output reg outbyte = 0,
                    output reg write_done);


    reg [DATA_WIDTH-1:0] bram [0:(2<<SIZE-1)-1];
    reg [7:0] byte1,byte2,byte3;
    wire [23:0] final;
    wire [11:0] ch1,ch2;
    reg [2:0] count;
    reg ready;
    wire [31:0] sample1,sample2;
    reg [31:0] scaled1,scaled2;
    assign sample1 = {byte2[3:0], byte3};                     // First 12-bit sample
    assign sample2 = {byte1, byte2[7:4]};                    // Second 12-bit sample
    assign final = {scaled2[11:0], scaled1[11:0]};
    assign ch2 = final [23:12];
    assign ch1 = final [11:0];
    always @(posedge clk) begin
        if (~resetn)
        begin
            byte1 <= 0;
            byte2 <= 0;
            byte3 <= 0;
            count <= 0;
            ready <= 0;
        end
        else begin
        scaled1 = (sample1-ADC_OFFSET)/SCALE;
        scaled2 = (sample2-ADC_OFFSET)/SCALE;
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
                        data_out <= 8'hFF;
                        outbyte <= 0;
                    end
                    else begin
                    data_out <= bram[rptr];
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
                    write_done <= 1;
                    count <= 0;
                end   
            else begin
                write_done <= 0;
            end         
        end
    end
endmodule
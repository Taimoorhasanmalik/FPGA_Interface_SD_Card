module accumulator #(parameter DATA_WIDTH = 8,
                    parameter SIZE = 8;

) (
                    input wire clk, resetn, en, rd, 
                    input wire [DATA_WIDTH-1:0] data_in,
                    output wire ready, 
                    output wire [DATA_WIDTH-1:0] data_out);
    reg [DATA_WIDTH-1:0] bram [0:(2<<SIZE)-1];
    reg [SIZE-1:0] wptr, rptr;
    always @(posedge clk) begin
        if (~resetn)
        begin
            wptr <= 0;
            rptr <= 0;
        end
        else begin
            if (en) begin
                bram [wptr] <= data_in;
                wptr <= wptr +1;
                if (wptr == 0)
                begin
                    ready <= 1'b1;
                end
            end
            if (rd && ready) begin
                data_out <= bram[rd];
                rd <= rd+1;
                if (rd == 0)
                begin
                    ready <= 0;
                end
            end
        end
    end
endmodule
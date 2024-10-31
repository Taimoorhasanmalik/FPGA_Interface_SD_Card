module bram_storage (
    input wire clk,
    input wire [7:0] data_in,    // Incoming SPI data
    input wire wr_en,            // Write enable signal
    input wire [9:0] addr,       // Address pointer (assume 10-bit address for 1K entries)
    output reg [7:0] data_out    // Output for reading stored data
);

    // Declare the memory array (for example, 1024 bytes)
    reg [7:0] bram [1023:0];
    // Write to BRAM on rising clock edge when wr_en is high
    always @(posedge clk) begin
        if (wr_en) begin
            bram[addr] <= data_in;   // Write incoming data to BRAM
        end
        data_out <= bram[addr];      // Read the data at the current address
    end

endmodule

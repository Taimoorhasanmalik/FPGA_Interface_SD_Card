
//--------------------------------------------------------------------------------------------------------
// Module  : fpga_top
// Type    : synthesizable, FPGA's top, IP's example design
// Standard: Verilog 2001 (IEEE1364-2001)
// Function: an example of sd_file_reader, read a file from SDcard via SPI, and send file content to UART
//           this example runs on Digilent Nexys4-DDR board (Xilinx Artix-7),
//           see http://www.digilent.com.cn/products/product-nexys-4-ddr-artix-7-fpga-trainer-board.html
//--------------------------------------------------------------------------------------------------------

module fpga_top (
    // clock = 100MHz
    input  wire         clk,
    // resetn active-low, You can re-scan and re-read SDcard by pushing the reset button.
    input  wire         resetn,
    input wire          next   ,
    // signals connect to SD SPI bus
    output wire         sd_spi_ssn,
    output wire         sd_spi_sck,
    output wire         sd_spi_mosi,
    input  wire         sd_spi_miso,
    // 8 bit led to show the status of SDcard
    output wire [15:0]  led,
    // UART tx signal, connected to host-PC's UART-RXD, baud=115200
    output wire         uart_tx,
    output wire [3:0] an,
    output wire [6:0] seg
);

//---------------------------------------------------------------------------------------------------
// sd_spi_file_reader
//----------------------------------------------------------------------------------------------------
wire       outen;     // when outen=1, a byte of file content is read out from outbyte
wire [7:0] outbyte;   // a byte of file content
wire [2:0] filesystem_stat;
sd_spi_file_reader #(
    .FILE_NAME_LEN  ( 11             ),  // the length of "example.txt" (in bytes)
    .FILE_NAME      ( "example.txt"  ),  // file name to read
    .SPI_CLK_DIV    ( 100             )   // because clk=50MHz, SPI_CLK_DIV is set to 50
) u_sd_spi_file_reader (
    .rstn           ( resetn         ),
    .clk            ( clk            ),
    .spi_ssn        ( sd_spi_ssn     ),
    .spi_sck        ( sd_spi_sck     ),
    .spi_mosi       ( sd_spi_mosi    ),
    .spi_miso       ( sd_spi_miso    ),
    .card_stat      ( led[3:0]       ),  // show the sdcard initialize status
    .card_type      ( led[5:4]       ),  // 0=UNKNOWN    , 1=SDv1    , 2=SDv2  , 3=SDHCv2
    .filesystem_type( led[7:6]       ),  // 0=UNASSIGNED , 1=UNKNOWN , 2=FAT16 , 3=FAT32 
    .filesystem_stat(   filesystem_stat             ),
    .file_found     ( led[  8]       ),  // 0=file not found, 1=file found
    .outen          ( outen          ),
    .outbyte        ( outbyte        )
);

reg [9:0] write_ptr = 10'b0;  // Address pointer for BRAM
reg wr_en = 0;                // Write enable signal
wire [7:0] data_out;         // Data output from BRAM
reg [9:0] addr;
reg [31:0] size_counter;
bram_storage bram (
     .clk(clk),
     .data_in(outbyte),    // Incoming SPI data
     .wr_en(wr_en),            // Write enable signal
     .addr(addr),       // Address pointer (assume 10-bit address for 1K entries)
     .data_out(data_out)    // Output for reading stored data);
);
//----------------------------------------------------------------------------------------------------
// send file content to UART
//----------------------------------------------------------------------------------------------------

// SPI data reception logic...
// Whenever data is received from SPI

reg [9:0] read_ptr = 10'b0;  // Read pointer
always @(posedge clk) begin
    if (outen) begin
        wr_en <= 1;
        addr <= write_ptr;  // Increment the pointer after writing
        write_ptr <= write_ptr +1;
    end else begin
        wr_en <= 0;
        if (filesystem_stat == 3'd6 )begin
            addr <= read_ptr;  // Increment the read pointer
            
            if (next)
            read_ptr <= read_ptr +1;
        end
        else read_ptr =0 ;
        end
    end

// display_bram_data display_inst (
//         .clk(clk),
//         .reset(resetn),
//         .bram_data(data_out),
//         .an(an),
//         .seg(seg),
//         .test_data(|outbyte)
//     );



endmodule

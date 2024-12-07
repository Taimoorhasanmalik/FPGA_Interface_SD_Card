
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
    .FILE_NAME_LEN  ( 8             ),  // the length of "example.txt" (in bytes)
    .FILE_NAME      ( "data.bin"  ),  // file name to read
    .SPI_CLK_DIV    ( 100             )   // because clk=100MHz, SPI_CLK_DIV is set to 100
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

wire [7:0] data_out;

accumulator acc (
    .clk(clk),
    .resetn(resetn),
    .data_in(outbyte),
    .en(outen),
    .data_out(data_out)
)



// uart_tx #(
//     .CLK_FREQ                  ( 100000000            ),    // clk is 50MHz
//     .BAUD_RATE                 ( 921600               ),
//     .PARITY                    ( "NONE"               ),
//     .STOP_BITS                 ( 1                    ),
//     .BYTE_WIDTH                ( 1                    ),
//     .FIFO_EA                   ( 14                   ),
//     .EXTRA_BYTE_AFTER_TRANSFER ( ""                   ),
//     .EXTRA_BYTE_AFTER_PACKET   ( ""                   )
// ) u_uart_tx (
//     .rstn                      ( resetn                 ),
//     .clk                       ( clk                  ),
//     .i_tready                  (                      ),
//     .i_tvalid                  ( outen                ),
//     .i_tdata                   ( outbyte              ),
//     .i_tkeep                   ( 1'b1                 ),
//     .i_tlast                   ( 1'b0                 ),
//     .o_uart_tx                 ( uart_tx              )
// );


endmodule

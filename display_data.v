module display_bram_data (
    input wire clk,               // 100 MHz clock
    input wire reset,             // Reset signal
    input wire [7:0] bram_data,   // Data from BRAM (8-bit)
    output reg [3:0] an,          // 7-segment display anode control
    output reg [6:0] seg,          // 7-segment display segment control
    input wire test_data
);

    reg dum;
    reg [25:0] refresh_counter = 0;  // Counter for refresh rate (to multiplex 7-segments)
    wire [1:0] display_select;       // Select which display is active
    reg [3:0] digit;                 // Current digit to display
    reg [7:0] data;                  // Data to be displayed (from BRAM)
    
    // 7-segment display refresh rate control
    always @(posedge clk) begin
        if (~reset) begin
            refresh_counter <= 0;
        end else begin
            refresh_counter <= refresh_counter + 1;
        end
        if (test_data)
            dum<= test_data; 
    end

    assign display_select = refresh_counter[19:18];  // Select one of 4 digits to update

    // Display digit selection (multiplexing between 4 digits)
    always @(*) begin
        data = bram_data;  // Data from BRAM (8-bit)
        
        case (display_select)
            2'b00: digit = data[3:0];   // Lower nibble of data
            2'b01: digit = data[7:4];   // Upper nibble of data
            2'b10: digit = dum;        // Display an 'F' (or any other constant data)
            2'b11: digit = 4'hA;        // Display an 'A' (or any other constant data)
        endcase
    end

    // Control which anode is on (for multiplexing 7-segment displays)
    always @(*) begin
        case (display_select)
            2'b00: an = 4'b1110;  // Enable digit 0 (lower nibble)
            2'b01: an = 4'b1101;  // Enable digit 1 (upper nibble)
            2'b10: an = 4'b1011;  // Enable digit 2
            2'b11: an = 4'b0111;  // Enable digit 3
        endcase
    end

    // 7-segment decoder (hexadecimal to 7-segment conversion)
    always @(*) begin
        case (digit)
            4'h0: seg = 7'b0000001;  // Display 0
            4'h1: seg = 7'b1001111;  // Display 1
            4'h2: seg = 7'b0010010;  // Display 2
            4'h3: seg = 7'b0000110;  // Display 3
            4'h4: seg = 7'b1001100;  // Display 4
            4'h5: seg = 7'b0100100;  // Display 5
            4'h6: seg = 7'b0100000;  // Display 6
            4'h7: seg = 7'b0001111;  // Display 7
            4'h8: seg = 7'b0000000;  // Display 8
            4'h9: seg = 7'b0000100;  // Display 9
            4'hA: seg = 7'b0001000;  // Display A
            4'hB: seg = 7'b1100000;  // Display B
            4'hC: seg = 7'b0110001;  // Display C
            4'hD: seg = 7'b1000010;  // Display D
            4'hE: seg = 7'b0110000;  // Display E
            4'hF: seg = 7'b0111000;  // Display F
            default: seg = 7'b1111111;  // Blank display

        endcase
    end

endmodule

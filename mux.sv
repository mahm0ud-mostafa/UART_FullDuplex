module mux(
    input logic S_DATA, PARITY_BIT,   
    input logic [1:0] MUX_SEL,            // select signal (coming from the controller)
    output logic TX_OUTPUT);               // final UART serial output (1bit)
    always_comb begin                     // mux output logic (combinational)
        case(MUX_SEL)
            2'b00: TX_OUTPUT = 1'b0;        // choose start bit
            2'b01: TX_OUTPUT = 1'b1;        // choose idle or stop bit
            2'b10: TX_OUTPUT = S_DATA;      // choose the serialized data bit
            2'b11: TX_OUTPUT = PARITY_BIT;  // choose the parity bit
            default: TX_OUTPUT = 1'b1;      // keep out high if selection not used
        endcase
    end
endmodule

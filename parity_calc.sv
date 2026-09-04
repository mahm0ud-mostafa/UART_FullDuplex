module parity_calc #(parameter W = 8)(        // W: data width parameter, default value is 8
    input logic [W-1:0] P_INPUT,              // parallel input data (W-bit bus)
    input logic P_BIT,                         // parity type: 0 for even and 1 for odd
    output logic PARITY_BIT);                  // calculated parity bit output
    assign PARITY_BIT = (^P_INPUT) ^ P_BIT;   // reduction XOR calculates the parity then P_BIT selects its type
endmodule

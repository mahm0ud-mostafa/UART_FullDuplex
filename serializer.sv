module serializer #(parameter W = 8)(                   // W: data width parameter, default value is 8
    input logic CLK, RST, LOAD, SHIFT_EN,                // input signals (1-bit each)
    input logic [W-1:0] P_DATA,                          // parallel data input (W-bit bus)
    output logic S_DATA);                                // serial data output (1-bit wire)
    logic [W-1:0] SHIFT_REG;
    always_ff@(posedge CLK or negedge RST) begin           // falling edge asynch. reset triggers the always block
        if(!RST)                                        // active-low reset. When activated, reset the shift register (highest priority)
            SHIFT_REG <= {W{1'b0}};                     // fill the shift register with W zeros (replication of 0 data width times)
        else if(LOAD)
            SHIFT_REG <= P_DATA;                        // load parallel data into the shift reg if LOAD input signal is high
        else if(SHIFT_EN)          
            SHIFT_REG <= SHIFT_REG >> 1;                // shift right the shift reg if SHIFT_EN input signal is high
    end
    assign S_DATA = SHIFT_REG[0];                       // continuously assign/connect the LSB of the shift reg to the serial data output wire
endmodule

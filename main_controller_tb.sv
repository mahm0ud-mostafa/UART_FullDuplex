`timescale 1ns/1ps
module main_controller_tb;
parameter W = 8;
logic CLK,RST,V_INPUT,P_EN;
logic LOAD,SHIFT_EN,BUSY;
logic [1:0] MUX_SEL;
main_controller #(.W(W)) DUT(.CLK(CLK), .RST(RST), .V_INPUT(V_INPUT), .P_EN(P_EN), .LOAD(LOAD), .SHIFT_EN(SHIFT_EN), .BUSY(BUSY), .MUX_SEL(MUX_SEL));
always #5 CLK = ~CLK;                                  // generate a clock with 10 ns period
always @(posedge CLK) begin
    #1;                                                // wait for outputs to update after the positive edge
    $display("time=%0t valid=%b p_en=%b load=%b shift=%b busy=%b sel=%b", $time,V_INPUT,P_EN,LOAD,SHIFT_EN,BUSY,MUX_SEL);
end
initial begin
    CLK=0; RST=0; V_INPUT=0; P_EN=0;      // set initial tb values and activate rst (since it's active-low)
    #12 RST=1;                            // deactivate reset (after 12ns)
    #8 P_EN=1; V_INPUT=1;                 // start 1st frame with parity enabled
    #10 V_INPUT=0;                        // valid input stays high for only one clock cycle
    #120;                               // wait until the first frame is completed
    P_EN=0; V_INPUT=1;                   // start second frame without parity
    #10 V_INPUT=0;
    #120;
    $display("controller test finished");
    $finish;
end
endmodule

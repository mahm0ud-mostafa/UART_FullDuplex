`timescale 1ns/1ps
module serializer_tb;
localparam W= 8;
logic CLK, RST, LOAD, SHIFT_EN;
logic [W-1:0] P_DATA;
logic S_DATA;
serializer #(.W(W)) DUT(.CLK(CLK), .RST(RST), .LOAD(LOAD), .SHIFT_EN(SHIFT_EN), .P_DATA(P_DATA), .S_DATA(S_DATA));
initial begin
    CLK = 1'b0;
    forever #5 CLK = !CLK;
end
initial begin
    RST=1'b0; // reset is low (active)
    LOAD=1'b0; 
    SHIFT_EN=1'b0;
    P_DATA={W{1'b0}};
    repeat(2) @(negedge CLK); // keep reset active for two cycles
    RST=1'b1;
    @(negedge CLK); // wait one cycle after reset
    P_DATA = 8'b10100010; // load A2 into the serializer input data bus 
    LOAD = 1'b1;
    @(negedge CLK); // setting LOAD to low across one posedge clk
    LOAD=1'b0; // setting LOAD to 0 again, so the parallel data input is already stored in the serializer's shift reg
    SHIFT_EN=1'b1;
    repeat(W) @(negedge CLK); //continue shifting for W clock cycles
    SHIFT_EN=1'b0; // stop shift
    @(negedge CLK); // wait for one cycle
    $display("Simulation of Serializer is Finished");
    $finish;
end
initial begin
    $monitor("Time=%0t | RST=%b LOAD=%b SHIFT_EN=%b P_DATA=%b SHIFT_REG=%b S_DATA=%b", $time, RST, LOAD, SHIFT_EN, P_DATA, DUT.SHIFT_REG, S_DATA);
end
endmodule

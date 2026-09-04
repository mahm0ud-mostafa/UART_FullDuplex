`timescale 1ns/1ps
module parity_calc_tb;
parameter W = 8;
logic [W-1:0] P_INPUT;
logic P_BIT;
logic PARITY_BIT;
parity_calc #(.W(W)) DUT(.P_INPUT(P_INPUT), .P_BIT(P_BIT), .PARITY_BIT(PARITY_BIT));
initial begin
    $monitor("time=%0t P_INPUT=%b P_BIT=%b PARITY_BIT=%b", $time,P_INPUT,P_BIT,PARITY_BIT);
    P_INPUT = 8'hA2; P_BIT = 1'b0; #10;     // A2 + even parity, out expected is 1
    P_INPUT = 8'hA2; P_BIT = 1'b1; #10;     // A2 + odd parity, out expected is 0
    P_INPUT = 8'hA3; P_BIT = 1'b0; #10;     // A3 + even parity, out expected is 0
    P_INPUT = 8'hA3; P_BIT = 1'b1; #10;     // A3 + odd parity, out expected is 1
    P_INPUT = 8'h00; P_BIT = 1'b0; #10;     // all zeros + even parity, out expected is 0
    P_INPUT = 8'h00; P_BIT = 1'b1; #10;     // all zeros + odd parity, out expected is 1
    $display("parity calculator test finished");
    $finish;
end
endmodule

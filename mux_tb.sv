`timescale 1ns/1ps
module mux_tb;
logic S_DATA;
logic PARITY_BIT;
logic [1:0] MUX_SEL;
logic TX_OUTPUT;
mux DUT(.S_DATA(S_DATA), .PARITY_BIT(PARITY_BIT), .MUX_SEL(MUX_SEL), .TX_OUTPUT(TX_OUTPUT));
initial begin
    $monitor("time=%0t MUX_SEL=%b S_DATA=%b PARITY=%b TX=%b", $time,MUX_SEL,S_DATA,PARITY_BIT,TX_OUTPUT);
    S_DATA=0; PARITY_BIT=1; MUX_SEL=2'b00; #10;      // chose start bit, Tx output should be 0
    MUX_SEL=2'b01; #10;                              // choose idle or stop bit, Tx output should be 1
    MUX_SEL=2'b10; #10;                              // choose serial data which is now 0
    S_DATA=1; #10;                                   // change serial data input to 1
    MUX_SEL=2'b11; #10;                              // choose parity bit which is now 1
    PARITY_BIT=0; #10;                              // change parity bit i/p to 0
    $display("mux test finished");
    $finish;
end
endmodule

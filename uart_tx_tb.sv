`timescale 1ns/1ps
module uart_tx_tb;
parameter DATA_W = 8;
logic [DATA_W-1:0] i_data;
logic i_valid,i_clk,i_rst_n,i_par_en,i_par_odd;
logic o_tx,o_busy;
uart_tx #(.DATA_W(DATA_W)) DUT(.i_data(i_data), .i_valid(i_valid), .i_clk(i_clk), .i_rst_n(i_rst_n), .i_par_en(i_par_en), .i_par_odd(i_par_odd), .o_tx(o_tx), .o_busy(o_busy));
always #5 i_clk = ~i_clk;                // generate clock with 10ns period
always @(posedge i_clk) begin
    #1;                              // wait for outputs to update (I had timing issues and searched for a solution, found none. Asked ChatGPT and it suggested this tiny edit; not sure why but doesn't hurt:)
    $display("time=%0t data=%h valid=%b p_en=%b p_bit=%b TX=%b BUSY=%b", $time,i_data,i_valid,i_par_en,i_par_odd,o_tx,o_busy);
end
initial begin
    i_clk=0; i_rst_n=0; i_valid=0;                           // set clock, reset and valid input initial values
    i_data=0; i_par_en=0; i_par_odd=0;                        // set data and parity inputs to zero
    #12 i_rst_n=1;                                         // deactivate the reset (active-low)
    #8 i_data=8'hA5; i_par_en=1; i_par_odd=0; i_valid=1;      // send A5 + even parity
    #10 i_valid=0;                                     // valid input high for one cycle only
    #30 i_data=8'hFF; i_par_en=0; i_par_odd=1; i_valid=1;     // this valid pulse occurs while BUSY and should be ignored, so it wouldn't alter transmission
    #10 i_valid=0;
    #70;
    i_data=8'h3C; i_par_en=1; i_par_odd=1; i_valid=1;       // send 3C +odd parity
    #10 i_valid=0;
    #120;
    i_data=8'h96; i_par_en=0; i_par_odd=0; i_valid=1;       // send 96 without parity
    #10 i_valid=0;
    #110;
    $display("UART TX test finished");
    $finish;
end
endmodule

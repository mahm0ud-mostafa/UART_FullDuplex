module edge_detector(
    input logic i_clk, i_rst_n, i_signal,
    output logic o_pos_edge, o_neg_edge, o_edge);
    
    logic delayed_signal;

    always_ff@(posedge i_clk or negedge i_rst_n) begin
        if(!i_rst_n)
            delayed_signal <= 1'b1;
        else
            delayed_signal <= i_signal;
    end

    assign o_pos_edge = i_signal & ~delayed_signal;
    assign o_neg_edge = ~i_signal & delayed_signal;
    assign o_edge = i_signal ^ delayed_signal;
endmodule

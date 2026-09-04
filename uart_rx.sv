module uart_rx #(parameter DATA_W = 8)(
    input logic i_rx, i_clk, i_rst_n, i_par_en, i_par_odd,
    output logic [DATA_W-1:0] o_data,
    output logic o_valid, o_busy, o_parity_err, o_frame_err);

    logic neg_edge_rx;
    logic sample_en;

    edge_detector edge_det(.i_clk(i_clk), .i_rst_n(i_rst_n), .i_signal(i_rx), .o_pos_edge(), .o_neg_edge(neg_edge_rx), .o_edge());
    
    deserializer #(.DATA_W(DATA_W)) des(.i_clk(i_clk), .i_rst_n(i_rst_n), .i_sample_en(sample_en), .i_serial_data(i_rx), .o_data(o_data));
    rx_main_controller #(.DATA_W(DATA_W)) control(.i_clk(i_clk), .i_rst_n(i_rst_n), .i_start_edge(neg_edge_rx), .i_rx(i_rx), .i_par_en(i_par_en),.i_par_odd(i_par_odd), .i_data(o_data), .o_sample_en(sample_en), .o_valid(o_valid), .o_busy(o_busy), .o_parity_err(o_parity_err), .o_frame_err(o_frame_err));

endmodule

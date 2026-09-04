module deserializer #(parameter DATA_W = 8)(
    input logic i_clk, i_rst_n, i_sample_en, i_serial_data,
    output logic [DATA_W-1:0] o_data);

    logic [DATA_W-1:0] shift_reg;

    always_ff@(posedge i_clk or negedge i_rst_n) begin
        if(!i_rst_n)
            shift_reg <= {DATA_W{1'b0}};
        else if(i_sample_en)
            shift_reg <= {i_serial_data, shift_reg[DATA_W-1:1]};
    end
    
    assign o_data = shift_reg;
endmodule

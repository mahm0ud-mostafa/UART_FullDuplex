module rx_main_controller #(parameter DATA_W =8)(
    input logic i_clk, i_rst_n, i_start_edge, i_rx, i_par_en, i_par_odd,
    input logic [DATA_W-1:0] i_data,
    output logic o_sample_en, o_valid, o_busy, o_parity_err, o_frame_err);

    typedef enum logic [1:0] {IDLE, DATA, PARITY, STOP} state_t;

    state_t current_state, next_state;
    localparam COUNT_W =(DATA_W<=1)?1:$clog2(DATA_W);
    logic [COUNT_W-1:0] bit_count;
    logic par_en_reg, par_odd_reg, parity_error_reg;

    always_ff@(posedge i_clk or negedge i_rst_n) begin
        if(!i_rst_n) begin
            current_state <=IDLE;
            bit_count <=0;
            par_en_reg <=1'b0;
            par_odd_reg <=1'b0;
            parity_error_reg <=1'b0;
            o_valid <=1'b0;
            o_parity_err <=1'b0;
            o_frame_err <=1'b0;
        end
        else begin
            current_state <=next_state;
            o_valid <=1'b0;
            o_parity_err <=1'b0;
            o_frame_err <=1'b0;
            if(current_state == IDLE&&i_start_edge) begin
                par_en_reg <=i_par_en;
                par_odd_reg <=i_par_odd;
                parity_error_reg <=1'b0;
            end
            if(current_state == DATA) begin
                if(bit_count == DATA_W-1)
                    bit_count <=0;
                else
                    bit_count <=bit_count+1'b1;
            end
            else
                bit_count <=0;
            if(current_state ==PARITY)
                parity_error_reg <=(i_rx != ((^i_data)^par_odd_reg));
            if(current_state ==STOP) begin
                o_valid <=1'b1;
                o_parity_err <=par_en_reg && parity_error_reg;
                o_frame_err <=~i_rx;
            end
        end
    end
    always_comb begin
        next_state =current_state;
        o_sample_en =1'b0;
        o_busy =1'b1;
        case(current_state)
            IDLE: begin
                o_busy =1'b0;
                if(i_start_edge)
                    next_state =DATA;
            end
            DATA: begin
                o_sample_en =1'b1;
                if(bit_count ==DATA_W-1) begin
                    if(par_en_reg)
                        next_state =PARITY;
                    else
                        next_state =STOP;
                end
            end
            PARITY: begin
                next_state =STOP;
            end
            STOP: begin
                next_state =IDLE;
            end
            default: begin
                o_busy =1'b0;
                next_state =IDLE;
            end
        endcase
    end
endmodule

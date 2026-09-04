module uart_tx #(parameter DATA_W = 8)(    // W: parallel data width param
    input logic [DATA_W-1:0] i_data,      // parallel input bus (of data width W)
    input logic i_valid,              // valid input signal (NOTE: assumed to be active for 1 clk cycle only)
    input logic i_clk,                  // system clock i/p
    input logic i_rst_n,                  // reset input (active-low)
    input logic i_par_en,                 // parity enable input
    input logic i_par_odd,                // parity type input (either even or odd)
    output logic o_tx,           // final transmitted bit (serial out bit) 
    output logic o_busy);               // high while UART is transmitting
    logic LOAD;                       // load control signal for serializer
    logic SHIFT_EN;                   // shift enabl control signal for serializer
    logic [1:0] MUX_SEL;              // mux select signal
    logic S_DATA;                     // serial data (serializer's out)
    logic CALC_PARITY;                // parity output before being saved
    logic saved_parity;                // saved parity bit for the current frame
    main_controller #(.W(DATA_W)) control_unit(.CLK(i_clk), .RST(i_rst_n), .V_INPUT(i_valid), .P_EN(i_par_en), .LOAD(LOAD), .SHIFT_EN(SHIFT_EN), .BUSY(o_busy), .MUX_SEL(MUX_SEL));
    serializer #(.W(DATA_W)) ser(.CLK(i_clk), .RST(i_rst_n), .LOAD(LOAD), .SHIFT_EN(SHIFT_EN), .P_DATA(i_data), .S_DATA(S_DATA));
    parity_calc #(.W(DATA_W)) parity_unit(.P_INPUT(i_data), .P_BIT(i_par_odd), .PARITY_BIT(CALC_PARITY));
    always_ff@(posedge i_clk or negedge i_rst_n) begin    // save parity when serializer loads a new input
        if(!i_rst_n)
            saved_parity <= 1'b0;                // clear saved parity if reset ( active-low)
        else if(LOAD)
            saved_parity <= CALC_PARITY;         // keep parity stable for the complete frame
    end
    mux output_mux(.S_DATA(S_DATA), .PARITY_BIT(saved_parity), .MUX_SEL(MUX_SEL), .TX_OUTPUT(o_tx));
endmodule

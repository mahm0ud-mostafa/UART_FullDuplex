module main_controller #(parameter W = 8)(    
    input logic CLK, RST, V_INPUT, P_EN,              
    output logic LOAD, SHIFT_EN, BUSY,
    output logic [1:0] MUX_SEL);                          // MUX_SEL controls which bit is sent on Tx o/p
    typedef enum logic [2:0] {IDLE = 3'b000, START= 3'b001, DATA = 3'b010, PARITY = 3'b011, STOP = 3'b100} state_t;   // states binary encoding
    state_t current_state, next_state;
    localparam COUNT_W = (W<=1)?1:$clog2(W);     // required width for data bit counter (searched for clog)
    logic [COUNT_W-1:0] bit_count;
    logic p_en_reg;                                       // saves P_EN for the current frame
    always_ff@(posedge CLK or negedge RST) begin           // state, counter and parity enable registers
        if(!RST) begin                                  // active-low asynch. reset, if activated, state= idle
            current_state <= IDLE;
            bit_count <= 0;
            p_en_reg <= 1'b0;
        end
        else begin
            current_state <=next_state;
            if(current_state ==IDLE&&V_INPUT)
                p_en_reg <=P_EN;                   // save parity enable when new input is accepted 
            if(current_state ==DATA) begin
                if(bit_count == W-1)
                    bit_count <= 0;                // reset counter after the last data bit
                else
                    bit_count <= bit_count + 1'b1;  // count the transmitted data bits
            end
            else
                bit_count <= 0;
        end
    end
    always_comb begin                            // next state + output logic
        next_state = current_state;             // default is to stay in the same state
        LOAD = 1'b0;
        SHIFT_EN = 1'b0;
        BUSY = 1'b1;
        MUX_SEL = 2'b01;
        case(current_state)
            IDLE: begin
                BUSY = 1'b0;              // Tx is free in IDLE state
                if(V_INPUT) begin
                    LOAD = 1'b1;          // load P_INPUT into the serializer
                    next_state = START;
                end
            end
            START: begin
                MUX_SEL = 2'b00;                // sel start bit (which is 0)
                next_state = DATA;
            end
            DATA: begin
                MUX_SEL = 2'b10;                // sel serializer output
                SHIFT_EN = 1'b1;
                if(bit_count == W-1) begin
                    if(p_en_reg)
                        next_state = PARITY;
                    else
                        next_state = STOP;
                end
            end
            PARITY: begin
                MUX_SEL = 2'b11;        // sel calculated parity bit
                next_state = STOP;
            end
            STOP: begin
                MUX_SEL = 2'b01;       // sel stop bit which is 1
                next_state = IDLE;
            end
            default: begin
                BUSY = 1'b0;
                next_state = IDLE;     // return to a safe state
            end
        endcase
    end
endmodule

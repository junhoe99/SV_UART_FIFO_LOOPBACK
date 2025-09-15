`timescale 1ns / 1ps

// -----------------------------------------------------------------------------------------------
/* module btn_debounce_edge (
    input  clk,
    input  rst,
    input  btn_num,
    output btn_edge
);

    wire w_btn_data;

    button_debounce U_BTN_DEBOUNCE (
        .clk(clk),
        .rst(rst),
        .in_num(btn_num),
        .out_num(w_btn_data)
    );

    edge_detector U_EDGE_DETECTOR (
        .clk(clk),
        .rst(rst),
        .i_data(w_btn_data),
        .up_edge(btn_edge)
    );

endmodule

module button_debounce (
    input  clk,
    input  rst,
    input  in_num,
    output out_num
);

    parameter IDLE = 2'b00, A = 2'b01, B = 2'b10, C = 2'b11;

    reg [1:0] c_state, n_state;
    reg out_num_reg;

    assign out_num = out_num_reg;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            c_state <= IDLE;
        end else begin
            c_state <= n_state;
        end
    end

    always @(*) begin
        n_state = c_state;
        out_num_reg = 1'b0;
        case (c_state)
            IDLE: begin
                if (in_num) begin
                    n_state = A;
                end
            end
            A: begin
                if (in_num) begin
                    n_state = B;
                end else begin
                    n_state = IDLE;
                end
            end
            B: begin
                if (in_num) begin
                    n_state = C;
                end else begin
                    n_state = IDLE;
                end
            end
            C: begin
                if (in_num) begin
                    out_num_reg = 1'b1;
                end else begin
                    n_state = IDLE;
                end
            end
        endcase
    end
endmodule

module edge_detector (
    input  clk,
    input  rst,
    input  i_data,
    output up_edge  ,
    output down_edge,
    output all_edge
);

    reg r_data_prev;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            r_data_prev <= 1'b0;
        end else begin
            r_data_prev <= i_data;
        end
    end

    assign up_edge = !r_data_prev && i_data;
    assign down_edge = r_data_prev && !i_data;
assign all_edge = i_data != r_data_prev;

endmodule */
// -----------------------------------------------------------------------------------------------


module btn_debounce_fsm (
    input clk,
    input rst,
    input i_btn,
    output o_btn
);

localparam [2:0] IDLE= 3'b000, A = 3'b001, B= 3'b010, C = 3'b011, D=3'b100 ;
    reg [2:0] state_reg, next_state;
    reg flag_reg, flag_next;
    reg o_btn_reg, o_btn_next;

assign o_btn = o_btn_reg;


always @(posedge clk, posedge rst) begin
    if (rst) begin
        state_reg <= IDLE;
        flag_reg <= 1'b0;
        o_btn_reg <= 1'b0;
    end else begin
         state_reg <= next_state;
         flag_reg <= flag_next;
         o_btn_reg <= o_btn_next;
    end
end

always @(*) begin
    next_state = state_reg;
    flag_next = flag_reg;
    o_btn_next = 1'b0;
    case (state_reg)
        IDLE : begin
            flag_next = 1'b0;
            if (i_btn) begin
                next_state = A;
            end
        end
        A: begin
            flag_next = 1'b0;
            if (i_btn) begin
                next_state = B;
            end else begin
                next_state = IDLE;
            end
        end
        B: begin
            flag_next = 1'b0;
            if (i_btn) begin
                next_state = C;
            end else begin
                next_state = IDLE;
            end
        end
        C: begin
            flag_next = 1'b0;
            if (i_btn) begin
                o_btn_next = 1'b1;
                next_state = D;
            end else begin
                next_state = IDLE;
            end
        end
        D: begin
            flag_next = 1'b1;
            if (i_btn) begin
                next_state = D;
            end else begin
                next_state = IDLE;
            end
        end
    endcase
end

endmodule
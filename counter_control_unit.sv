`timescale 1ns / 1ps

module counter_control_unit (
    input  clk,
    input  rst,
    input  i_enable,
    input  i_clear,
    input  i_mode,
    output o_enable,
    output o_clear,
    output o_mode
);

    parameter IDLE = 1'b0, CMD = 1'b1;

    reg c_state, n_state;
    reg enable_reg, enable_next;
    reg clear_reg, clear_next;
    reg mode_reg, mode_next;

    assign o_enable = enable_reg;
    assign o_clear  = clear_reg;
    assign o_mode   = mode_reg;

    // 레지스터 갱신
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c_state    <= IDLE;
            enable_reg <= 1;
            clear_reg  <= 0;
            mode_reg   <= 0;
        end else begin
            c_state    <= n_state;
            enable_reg <= enable_next;
            clear_reg  <= clear_next;
            mode_reg   <= mode_next;
        end
    end

    // 조합 논리
    always @(*) begin
        n_state   = c_state;
        enable_next  = enable_reg;
        clear_next   = 1'b0;
        mode_next    = mode_reg;

        case (c_state)
            IDLE: begin
                if (i_enable || i_clear || i_mode) begin
                    n_state = CMD;
                    if (i_enable) begin
                        enable_next = ~enable_reg;
                    end else if (i_clear) begin
                        clear_next = 1'b1;
                    end else if (i_mode) begin
                        mode_next = ~mode_reg;
                    end
                end
            end

            CMD: begin
                n_state = IDLE;
            end
        endcase
    end
endmodule

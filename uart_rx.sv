`timescale 1ns / 1ps

module uart_rx (
    input        clk,
    input        rst,
    input        tick,
    input        rx,
    output [7:0] rx_data,
    output       rx_done
);

    parameter [1:0] IDLE = 0, START = 1, DATA = 2, STOP = 3;
    reg [1:0] c_state, n_state;

    reg [4:0] tick_cnt_reg, tick_cnt_next;
    reg [2:0] bit_cnt_reg, bit_cnt_next;

    reg rx_done_reg, rx_done_next;
    reg [7:0] rx_buf_reg, rx_buf_next;

    assign rx_data = rx_buf_reg;
    assign rx_done = rx_done_reg;


    // State register
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            c_state <= IDLE;
            tick_cnt_reg <= 0;
            bit_cnt_reg <= 0;
            rx_done_reg <= 0;
            rx_buf_reg <= 0;
        end else begin
            c_state <= n_state;
            tick_cnt_reg <= tick_cnt_next;
            bit_cnt_reg <= bit_cnt_next;
            rx_done_reg <= rx_done_next;
            rx_buf_reg <= rx_buf_next;
        end
    end

    // Next-state logic
    always @(*) begin
        n_state = c_state;
        tick_cnt_next = tick_cnt_reg;
        bit_cnt_next = bit_cnt_reg;
        rx_done_next = rx_done_reg;
        rx_buf_next = rx_buf_reg;
        case (c_state)
            IDLE: begin
                rx_done_next = 0;
                    if (!rx) begin
                        tick_cnt_next = 0;
                        n_state = START;
                    end
            end
            
            START: begin
                if (tick) begin
                    if (tick_cnt_reg == 23) begin
                        tick_cnt_next = 0;
                        bit_cnt_next = 0;
                        n_state = DATA;
                    end else begin
                        tick_cnt_next = tick_cnt_reg + 1;
                    end
                end
            end

            DATA: begin
            if (tick) begin
                if (tick_cnt_reg == 7) begin
                    rx_buf_next = {rx, rx_buf_reg[7:1]};
                end

                if (tick_cnt_reg == 15) begin
                    tick_cnt_next = 0; 
                    if (bit_cnt_reg == 7) begin
                        n_state = STOP; 
                    end else begin
                        bit_cnt_next = bit_cnt_reg + 1;
                    end
                end else begin
                    tick_cnt_next = tick_cnt_reg + 1;
                end
            end
        end
            
            STOP: begin
                if (tick) begin
                    rx_done_next = 1'b1;
                    n_state = IDLE;
                end
            end
            default: begin
                n_state = IDLE;
                bit_cnt_next = 0;
                tick_cnt_next = 0;
                rx_done_next = 0;
            end
        endcase
    end



endmodule

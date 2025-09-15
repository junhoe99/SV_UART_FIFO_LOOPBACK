`timescale 1ns / 1ps


module counter_top (
    input        clk,
    input        rst,
    input        rx,
    input        mode,
    input        enable,
    input        clear,
    output       tx,
    output [7:0] fnd_data,
    output [3:0] fnd_com
);

    wire [13:0] w_counter;
    wire w_enable, w_mode, w_clear;
    wire w_btn_enable, w_btn_mode, w_btn_clear;
    wire w_uart_enable, w_uart_mode, w_uart_clear;

    wire [7:0] w_rx_data;
    wire w_rx_done;

    reg r_enable, r_mode, r_clear;


    btn_debounce_fsm U_BTN_ENABLE (
        .clk  (clk),
        .rst  (rst),
        .i_btn(enable),
        .o_btn(w_btn_enable)
    );

    btn_debounce_fsm U_BTN_CLEAR (
        .clk  (clk),
        .rst  (rst),
        .i_btn(clear),
        .o_btn(w_btn_clear)
    );


    btn_debounce_fsm U_BTN_MODE (
        .clk  (clk),
        .rst  (rst),
        .i_btn(mode),
        .o_btn(w_btn_mode)
    );

    uart_top U_UART (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_data(w_rx_data),
        .rx_done(w_rx_done),
        .tx(tx)
    );

    command_control_unit U_CMD_CU (
        .clk(clk),
        .rst(rst),
        .i_rx_data(w_rx_data),
        .i_rx_done(w_rx_done),
        .o_run(w_uart_enable),
        //.o_stop(),
        .o_clear(w_uart_clear),
        .o_mode(w_uart_mode)
    );


    assign r_final_enable = w_btn_enable | w_uart_enable;
    assign r_final_mode = w_btn_mode | w_uart_mode;
    assign r_final_clear = w_btn_clear | w_uart_clear;


    counter_control_unit U_COUNTER_CU (
        .clk(clk),
        .rst(rst),
        .i_enable(r_final_enable),
        .i_clear(r_final_clear),
        .i_mode(r_final_mode),
        .o_enable(w_enable),
        .o_clear(w_clear),
        .o_mode(w_mode)
    );

    counter_datapath U_DP (
        .clk(clk),
        .rst(rst),
        .mode(w_mode),
        .clear(w_clear),
        .enable(w_enable),
        .o_counter(w_counter)
    );

    fnd_controller U_FND_CNTL (
        .clk(clk),
        .rst(rst),
        .i_counter(w_counter),
        .fnd_com(fnd_com),
        .fnd_data(fnd_data)
    );
endmodule



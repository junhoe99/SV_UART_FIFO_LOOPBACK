`timescale 1ns / 1ps

module uart_top (
    input        clk,
    input        rst,
    input        rx,
    output [7:0] rx_data,
    output       rx_done,
    output       tx
);

    wire w_tick;
    wire w_rx_done;
    //wire w_done_start;
    wire w_tx_fifo_empty;
    wire w_tx_busy;
    wire w_rx_empty;
    wire w_tx_fifo_full;
    wire [7:0] w_rx_data, w_fifo_data, w_tx_data;
    
    assign rx_data = w_rx_data;
    assign rx_done = w_rx_done;

    baud_tick_gen U_BAUD_TICK_GEN (
        .rst (rst),
        .clk (clk),
        .tick(w_tick)
    );

    uart_rx U_UART_RX (
        .clk(clk),
        .rst(rst),
        .tick(w_tick),
        .rx(rx),
        .rx_data(w_rx_data),
        .rx_done(w_rx_done)
    );

    fifo U_UART_RX_FIFO (
        .clk(clk),
        .rst(rst),
        .wr(w_rx_done),
        .rd(~w_tx_fifo_full),
        .wdata(w_rx_data),
        .rdata(w_fifo_data),
        .full(),
        .empty(w_rx_empty)
    );

    fifo U_UART_TX_FIFO (
        .clk(clk),
        .rst(rst),
        .wr(~w_rx_empty),
        .rd(~w_tx_busy),
        .wdata(w_fifo_data),
        .rdata(w_tx_data),
        .full(w_tx_fifo_full),
        .empty(w_tx_fifo_empty)
    );

    uart_tx U_UART_TX (
        .clk(clk),
        .rst(rst),
        .tx_start(~w_tx_fifo_empty),
        .tx_data(w_tx_data),
        .tick(w_tick),
        .tx_busy(w_tx_busy),
        .tx(tx)
    );

    

    

    


endmodule

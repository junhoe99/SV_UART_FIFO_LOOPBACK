`timescale 1ns / 1ps

module counter_datapath (
    input         clk,
    input         rst,
    input         mode,
    input         enable,
    input         clear,
    output [13:0] o_counter
);
    wire w_tick_10hz;

    tick_gen_10hz U_TICK_GEN_10HZ (
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .enable(enable),
        .o_tick_10hz(w_tick_10hz)
    );

    counter_10000 U_COUNTER_10000 (
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .i_tick(w_tick_10hz),
        .mode(mode),
        .counter(o_counter)
    );

endmodule



module tick_gen_10hz (
    input  clk,
    input  rst,
    input  clear,
    input  enable,
    output o_tick_10hz
);
    parameter FCOUNT = 10_000_000;
    reg [$clog2(FCOUNT)-1:0] r_counter;
    reg r_tick_10hz;

    assign o_tick_10hz = r_tick_10hz;

    always @(posedge clk, posedge rst) begin
        if (rst | clear) begin
            r_counter   <= 0;
            r_tick_10hz <= 0;
        end else begin
            if (enable) begin
                r_counter   <= r_counter + 1;
                r_tick_10hz <= 1'b0;
                if (r_counter == FCOUNT - 1) begin
                    r_counter   <= 0;
                    r_tick_10hz <= 1'b1;
                end
            end
        end
    end
endmodule


module counter_10000 (
    input clk,
    input rst,
    input clear,
    input i_tick,
    input mode,
    output [13:0] counter
);
    reg [13:0] r_counter;
    assign counter = r_counter;

    always @(posedge clk, posedge rst) begin
        if (rst | clear) begin
            r_counter <= 0;
        end else begin
            if (i_tick) begin
                if (!mode) begin
                    if (r_counter == 10000 - 1) begin
                        r_counter <= 0;
                    end else begin
                        r_counter <= r_counter + 1;
                    end
                end else begin
                    if (r_counter == 0) begin
                        r_counter <= 10000 - 1;
                    end else begin
                        r_counter <= r_counter - 1;
                    end
                end
            end
        end
    end
endmodule



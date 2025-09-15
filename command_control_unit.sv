`timescale 1ns / 1ps


module command_control_unit (
    input        clk,
    input        rst,
    input  [7:0] i_rx_data,
    input        i_rx_done,
    output       o_run,
    //output o_stop,
    output       o_clear,
    output       o_mode
);

    reg r_run, r_stop, r_clear, r_mode;

    assign o_run   = r_run;
    //assign o_stop = r_stop;
    assign o_clear = r_clear;
    assign o_mode  = r_mode;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            r_run   <= 0;
            r_clear <= 0;
            r_mode  <= 0;
        end else begin
            r_run   <= 0;
            r_clear <= 0;
            r_mode  <= 0;
            if (i_rx_done) begin
                case (i_rx_data)
                    "r": r_run <= 1'b1;
                    "c": r_clear <= 1'b1;
                    "m": r_mode <= 1'b1;
                endcase
            end
        end
    end



    /* always @(*) begin
    r_run = 1'b0;
    //r_stop = 1'b0;
    r_clear = 1'b0;
    r_mode = 1'b0;

    if(i_rx_done)begin
        case(i_rx_data)
        "r" :r_run = 1'b1;
        //"s" : r_stop = 1'b1;
        "c" : r_clear = 1'b1;
        "m" : r_mode = 1'b1;
        endcase
    end
end */
endmodule

`timescale 1ns/1ps

module ras_performance_monitor #(
    parameter integer MAX_PES = 8
)(
    input  logic clk,
    input  logic rst,

    input  logic start,
    input  logic busy,
    input  logic done,

    input  logic [3:0] active_pe_count,

    output logic [31:0] cycle_count,
    output logic [31:0] active_pe_cycles,

    output logic [31:0] utilization,
    output logic        completed
);

    logic monitoring;
    logic calc_pending;
    logic output_pending;

    logic [31:0] utilization_next;

    always_ff @(posedge clk) begin

        if (rst) begin
            cycle_count      <= 32'd0;
            active_pe_cycles <= 32'd0;
            utilization      <= 32'd0;
            utilization_next <= 32'd0;

            monitoring       <= 1'b0;
            completed        <= 1'b0;
            calc_pending     <= 1'b0;
            output_pending   <= 1'b0;
        end
        else begin

            completed <= 1'b0;

            if (start) begin
                cycle_count      <= 32'd0;
                active_pe_cycles <= 32'd0;
                utilization      <= 32'd0;
                utilization_next <= 32'd0;

                monitoring     <= 1'b1;
                calc_pending   <= 1'b0;
                output_pending <= 1'b0;
            end

            else if (monitoring && busy) begin
                cycle_count      <= cycle_count + 1;
                active_pe_cycles <= active_pe_cycles + active_pe_count;
            end

            if (monitoring && done) begin
                monitoring   <= 1'b0;
                calc_pending <= 1'b1;
            end

            if (calc_pending) begin
                calc_pending <= 1'b0;

                if (cycle_count != 0)
                    utilization_next <= (active_pe_cycles * 32'd125) >> 3;
                else
                    utilization_next <= 32'd0;

                output_pending <= 1'b1;
            end

            if (output_pending) begin
                output_pending <= 1'b0;
                utilization    <= utilization_next;
                completed      <= 1'b1;
            end

        end
    end

endmodule
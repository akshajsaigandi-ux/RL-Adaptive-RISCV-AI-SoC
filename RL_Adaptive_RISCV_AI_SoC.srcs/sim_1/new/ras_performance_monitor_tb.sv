`timescale 1ns/1ps

module ras_performance_monitor_tb;

    localparam integer MAX_PES = 8;

    logic clk;
    logic rst;

    logic start;
    logic busy;
    logic done;

    logic [3:0] active_pe_count;

    logic [31:0] cycle_count;
    logic [31:0] active_pe_cycles;
    logic [31:0] utilization;
    logic        completed;

    ras_performance_monitor #(
        .MAX_PES(MAX_PES)
    ) dut (
        .clk(clk),
        .rst(rst),

        .start(start),
        .busy(busy),
        .done(done),

        .active_pe_count(active_pe_count),

        .cycle_count(cycle_count),
        .active_pe_cycles(active_pe_cycles),

        .utilization(utilization),
        .completed(completed)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;

        rst = 1'b1;
        start = 1'b0;
        busy = 1'b0;
        done = 1'b0;

        active_pe_count = 4'd0;

        // ------------------------------------------------
        // Reset
        // ------------------------------------------------

        #12;

        rst = 1'b0;

        // ------------------------------------------------
        // Start measurement
        // ------------------------------------------------

        @(negedge clk);

        start = 1'b1;
        active_pe_count = 4'd4;

        @(negedge clk);

        start = 1'b0;
        busy = 1'b1;

        // ------------------------------------------------
        // 4 active PEs for 4 cycles
        // ------------------------------------------------

        repeat (4)
            @(negedge clk);

        // ------------------------------------------------
        // Finish
        // ------------------------------------------------

        busy = 1'b0;
        done = 1'b1;

        @(negedge clk);

        done = 1'b0;

        #2;

        $display("--------------------------------");
        $display("PERFORMANCE MONITOR TEST");
        $display("Cycle count      = %0d",
                 cycle_count);
        $display("Active PE cycles = %0d",
                 active_pe_cycles);
        $display("Utilization      = %0d / 1000",
                 utilization);
        $display("Completed        = %0d",
                 completed);
        $display("--------------------------------");

        // Four cycles × four active PEs
        assert(cycle_count == 32'd4)
            else $error(
                "Cycle count incorrect"
            );

        assert(active_pe_cycles == 32'd16)
            else $error(
                "Active PE cycle count incorrect"
            );

        // 4/(8) = 50%
        // Scaled by 1000 = 500
        assert(utilization == 32'd500)
            else $error(
                "Utilization incorrect"
            );

        $display("PERFORMANCE MONITOR TEST PASSED");

        $finish;

    end

endmodule
`timescale 1ns/1ps

module ras_rl_state_encoder_tb;

    logic [31:0] utilization;
    logic [31:0] cycle_count;
    logic [3:0]  active_pe_count;

    logic [3:0] state;

    ras_rl_state_encoder dut (

        .utilization(utilization),
        .cycle_count(cycle_count),
        .active_pe_count(active_pe_count),

        .state(state)
    );


    initial begin

        // --------------------------------------------
        // State 0
        // Low utilization + Fast
        // --------------------------------------------

        utilization    = 32'd100;
        cycle_count    = 32'd5;
        active_pe_count = 4'd2;

        #10;

        assert(state == 4'd0)
            else $error(
                "Expected state 0, got %0d",
                state
            );


        // --------------------------------------------
        // State 1
        // Low utilization + Medium
        // --------------------------------------------

        utilization = 32'd100;
        cycle_count = 32'd15;

        #10;

        assert(state == 4'd1)
            else $error(
                "Expected state 1, got %0d",
                state
            );


        // --------------------------------------------
        // State 2
        // Low utilization + Slow
        // --------------------------------------------

        utilization = 32'd100;
        cycle_count = 32'd25;

        #10;

        assert(state == 4'd2)
            else $error(
                "Expected state 2, got %0d",
                state
            );


        // --------------------------------------------
        // State 4
        // Medium utilization + Medium
        // --------------------------------------------

        utilization = 32'd500;
        cycle_count = 32'd15;

        #10;

        assert(state == 4'd4)
            else $error(
                "Expected state 4, got %0d",
                state
            );


        // --------------------------------------------
        // State 6
        // High utilization + Fast
        // --------------------------------------------

        utilization = 32'd900;
        cycle_count = 32'd5;

        #10;

        assert(state == 4'd6)
            else $error(
                "Expected state 6, got %0d",
                state
            );


        // --------------------------------------------
        // State 8
        // High utilization + Slow
        // --------------------------------------------

        utilization = 32'd900;
        cycle_count = 32'd25;

        #10;

        assert(state == 4'd8)
            else $error(
                "Expected state 8, got %0d",
                state
            );


        $display("--------------------------------");
        $display("RL STATE ENCODER TEST PASSED");
        $display("Final state = %0d", state);
        $display("--------------------------------");

        $finish;

    end

endmodule
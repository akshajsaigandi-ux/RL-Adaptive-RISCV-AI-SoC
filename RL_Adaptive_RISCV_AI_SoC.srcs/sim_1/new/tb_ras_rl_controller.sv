`timescale 1ns / 1ps

module tb_ras_rl_controller;

    logic clk;
    logic rst;

    logic start;
    logic done;

    logic [31:0] cycle_count;
    logic [31:0] utilization;

    logic [1:0] action;
    logic [3:0] active_pe_count;
    logic [3:0] current_state;

    logic signed [15:0] reward;
    logic learning_valid;


    // ==================================================
    // DUT
    // ==================================================

    ras_rl_controller dut (
        .clk(clk),
        .rst(rst),

        .start(start),
        .done(done),

        .cycle_count(cycle_count),
        .utilization(utilization),

        .action(action),
        .active_pe_count(active_pe_count),

        .current_state(current_state),

        .reward(reward),

        .learning_valid(learning_valid)
    );


    // ==================================================
    // Clock
    // ==================================================

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end


    // ==================================================
    // Test
    // ==================================================

    initial begin

        rst = 1'b1;
        start = 1'b0;
        done = 1'b0;

        cycle_count = 32'd30;
        utilization = 32'd100;

        #20;

        rst = 1'b0;

        #10;


        $display("");
        $display("==============================================");
        $display(" 9-STATE TRAINED RL POLICY VERIFICATION");
        $display("==============================================");
        $display("");


        // ==================================================
        // STATE 0
        //
        // Utilization = LOW
        // Performance = FAST
        //
        // Expected action = 2
        // Expected PE = 8
        // ==================================================

        utilization = 32'd100;
        cycle_count = 32'd5;

        #10;

        $display(
            "STATE 0 TEST: state=%0d action=%0d PE=%0d",
            current_state,
            action,
            active_pe_count
        );


        // ==================================================
        // STATE 1
        //
        // Utilization = LOW
        // Performance = MEDIUM
        //
        // Expected action = 2
        // Expected PE = 8
        // ==================================================

        utilization = 32'd100;
        cycle_count = 32'd15;

        #10;

        $display(
            "STATE 1 TEST: state=%0d action=%0d PE=%0d",
            current_state,
            action,
            active_pe_count
        );


        // ==================================================
        // STATE 2
        //
        // Utilization = LOW
        // Performance = SLOW
        //
        // Expected action = 1
        // Expected PE = 4
        // ==================================================

        utilization = 32'd100;
        cycle_count = 32'd30;

        #10;

        $display(
            "STATE 2 TEST: state=%0d action=%0d PE=%0d",
            current_state,
            action,
            active_pe_count
        );


        // ==================================================
        // STATE 3
        //
        // Utilization = MEDIUM
        // Performance = FAST
        //
        // Expected action = 1
        // Expected PE = 4
        // ==================================================

        utilization = 32'd500;
        cycle_count = 32'd5;

        #10;

        $display(
            "STATE 3 TEST: state=%0d action=%0d PE=%0d",
            current_state,
            action,
            active_pe_count
        );


        // ==================================================
        // STATE 4
        //
        // Utilization = MEDIUM
        // Performance = MEDIUM
        //
        // Expected action = 2
        // Expected PE = 8
        // ==================================================

        utilization = 32'd500;
        cycle_count = 32'd15;

        #10;

        $display(
            "STATE 4 TEST: state=%0d action=%0d PE=%0d",
            current_state,
            action,
            active_pe_count
        );


        // ==================================================
        // STATE 5
        //
        // Utilization = MEDIUM
        // Performance = SLOW
        //
        // Expected action = 2
        // Expected PE = 8
        // ==================================================

        utilization = 32'd500;
        cycle_count = 32'd30;

        #10;

        $display(
            "STATE 5 TEST: state=%0d action=%0d PE=%0d",
            current_state,
            action,
            active_pe_count
        );


        // ==================================================
        // STATE 6
        //
        // Utilization = HIGH
        // Performance = FAST
        //
        // Expected action = 1
        // Expected PE = 4
        // ==================================================

        utilization = 32'd800;
        cycle_count = 32'd5;

        #10;

        $display(
            "STATE 6 TEST: state=%0d action=%0d PE=%0d",
            current_state,
            action,
            active_pe_count
        );


        // ==================================================
        // STATE 7
        //
        // Utilization = HIGH
        // Performance = MEDIUM
        //
        // Expected action = 0
        // Expected PE = 2
        // ==================================================

        utilization = 32'd800;
        cycle_count = 32'd15;

        #10;

        $display(
            "STATE 7 TEST: state=%0d action=%0d PE=%0d",
            current_state,
            action,
            active_pe_count
        );


        // ==================================================
        // STATE 8
        //
        // Utilization = HIGH
        // Performance = SLOW
        //
        // Expected action = 2
        // Expected PE = 8
        // ==================================================

        utilization = 32'd800;
        cycle_count = 32'd30;

        #10;

        $display(
            "STATE 8 TEST: state=%0d action=%0d PE=%0d",
            current_state,
            action,
            active_pe_count
        );


        // ==================================================
        // Episode learning test
        // ==================================================

        $display("");
        $display("Testing hardware Q-learning update...");


        start = 1'b1;

        #10;

        start = 1'b0;

        #20;

        done = 1'b1;

        #10;

        done = 1'b0;

        #10;

        $display(
            "learning_valid = %0d",
            learning_valid
        );


        // ==================================================
        // Finish
        // ==================================================

        $display("");
        $display("==============================================");
        $display(" 9-STATE VERIFICATION COMPLETE");
        $display("==============================================");

        #20;

        $finish;

    end

endmodule
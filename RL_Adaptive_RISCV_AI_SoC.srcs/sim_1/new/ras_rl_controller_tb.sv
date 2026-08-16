`timescale 1ns/1ps

module ras_rl_controller_tb;

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


    always #5 clk = ~clk;


    initial begin

        clk = 1'b0;

        rst = 1'b1;

        start = 1'b0;
        done = 1'b0;

        cycle_count = 32'd0;
        utilization = 32'd0;


        // ================================================
        // Reset
        // ================================================

        #12;

        rst = 1'b0;

        #3;


        // ================================================
        // Episode 1
        //
        // Fast + high utilization
        // Expected reward = +15
        // ================================================

        cycle_count = 32'd5;
        utilization = 32'd900;

        @(negedge clk);

        start = 1'b1;

        @(negedge clk);

        start = 1'b0;

        // Accelerator runs
        repeat (4)
            @(negedge clk);

        done = 1'b1;

        @(negedge clk);

        done = 1'b0;

        #2;

        assert(learning_valid == 1'b1)
            else $error(
                "Learning valid was not asserted"
            );

        assert(reward == 16'sd15)
            else $error(
                "Expected reward 15, got %0d",
                reward
            );


        // ================================================
        // Episode 2
        //
        // Slow + low utilization
        // Expected reward = -7
        // ================================================

        cycle_count = 32'd30;
        utilization = 32'd200;

        @(negedge clk);

        start = 1'b1;

        @(negedge clk);

        start = 1'b0;

        repeat (4)
            @(negedge clk);

        done = 1'b1;

        @(negedge clk);

        done = 1'b0;

        #2;


        assert(reward == -16'sd7)
            else $error(
                "Expected reward -7, got %0d",
                reward
            );


        // ================================================
        // Display
        // ================================================

        $display("-----------------------------------------");
        $display("INTEGRATED RL CONTROLLER TEST PASSED");
        $display("Current state  = %0d", current_state);
        $display("Action          = %0d", action);
        $display("Active PEs      = %0d", active_pe_count);
        $display("Reward          = %0d", reward);
        $display("-----------------------------------------");

        $finish;

    end

endmodule
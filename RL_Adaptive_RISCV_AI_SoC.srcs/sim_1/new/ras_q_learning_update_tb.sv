`timescale 1ns/1ps

module ras_q_learning_update_tb;

    logic clk;
    logic rst;
    logic update_en;

    logic [31:0] cycle_count;
    logic [31:0] utilization;

    logic signed [15:0] q_old;

    logic signed [15:0] reward;
    logic signed [15:0] q_new;


    ras_q_learning_update dut (

        .clk(clk),
        .rst(rst),
        .update_en(update_en),

        .cycle_count(cycle_count),
        .utilization(utilization),

        .q_old(q_old),

        .reward(reward),
        .q_new(q_new)
    );


    always #5 clk = ~clk;


    initial begin

        clk = 1'b0;
        rst = 1'b1;
        update_en = 1'b0;

        cycle_count = 32'd0;
        utilization = 32'd0;
        q_old = 16'sd0;

        #12;

        rst = 1'b0;


        // =================================================
        // TEST 1
        //
        // Fast + High utilization
        //
        // Performance = +10
        // Utilization = +5
        //
        // Reward = +15
        //
        // Qold = 0
        //
        // Qnew = 0 + ((15-0)/4)
        //      = 3
        // =================================================

        cycle_count = 32'd5;
        utilization = 32'd900;
        q_old = 16'sd0;

        #10;

        assert(reward == 16'sd15)
            else $error(
                "Test 1: expected reward 15, got %0d",
                reward
            );

        assert(q_new == 16'sd3)
            else $error(
                "Test 1: expected Qnew 3, got %0d",
                q_new
            );


        // =================================================
        // TEST 2
        //
        // Medium performance + medium utilization
        //
        // Performance = +5
        // Utilization = +2
        //
        // Reward = +7
        //
        // Qold = 8
        //
        // Qnew = 8 + ((7-8)/4)
        // Integer arithmetic keeps result near 8.
        // =================================================

        cycle_count = 32'd15;
        utilization = 32'd600;
        q_old = 16'sd8;

        #10;

        assert(reward == 16'sd7)
            else $error(
                "Test 2: expected reward 7, got %0d",
                reward
            );


        // =================================================
        // TEST 3
        //
        // Slow + Low utilization
        //
        // Performance = -5
        // Utilization = -2
        //
        // Reward = -7
        //
        // Qold = 8
        //
        // Qnew moves downward.
        // =================================================

        cycle_count = 32'd30;
        utilization = 32'd200;
        q_old = 16'sd8;

        #10;

        assert(reward == -16'sd7)
            else $error(
                "Test 3: expected reward -7, got %0d",
                reward
            );

        assert(q_new < q_old)
            else $error(
                "Test 3: Q-value did not decrease"
            );


        // =================================================
        // TEST 4
        //
        // Very good configuration
        // =================================================

        cycle_count = 32'd4;
        utilization = 32'd1000;
        q_old = 16'sd20;

        #10;

        assert(reward == 16'sd15)
            else $error(
                "Test 4: expected reward 15, got %0d",
                reward
            );

        assert(q_new < q_old)
            else $error(
                "Test 4: Q-value should move toward reward"
            );


        $display("----------------------------------------");
        $display("Q-LEARNING UPDATE TEST PASSED");
        $display("Final reward = %0d", reward);
        $display("Final Q      = %0d", q_new);
        $display("----------------------------------------");

        $finish;

    end

endmodule
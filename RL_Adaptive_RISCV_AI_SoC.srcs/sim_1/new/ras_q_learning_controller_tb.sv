`timescale 1ns/1ps

module ras_q_learning_controller_tb;

    logic clk;
    logic rst;

    logic [3:0] state;

    logic [1:0] action;
    logic [3:0] active_pe_count;


    ras_q_learning_controller dut (

        .clk(clk),
        .rst(rst),

        .state(state),

        .action(action),
        .active_pe_count(active_pe_count)
    );


    always #5 clk = ~clk;


    initial begin

        clk   = 1'b0;
        rst   = 1'b1;
        state = 4'd0;

        // ------------------------------------------------
        // Reset
        // ------------------------------------------------

        #12;

        rst = 1'b0;

        #2;


        // ------------------------------------------------
        // State 0
        // Expected action = 0
        // Expected PE count = 2
        // ------------------------------------------------

        state = 4'd0;

        #10;

        assert(action == 2'd0)
            else $error(
                "State 0: expected action 0, got %0d",
                action
            );

        assert(active_pe_count == 4'd2)
            else $error(
                "State 0: expected 2 PEs, got %0d",
                active_pe_count
            );


        // ------------------------------------------------
        // State 4
        // Expected action = 1
        // Expected PE count = 4
        // ------------------------------------------------

        state = 4'd4;

        #10;

        assert(action == 2'd1)
            else $error(
                "State 4: expected action 1, got %0d",
                action
            );

        assert(active_pe_count == 4'd4)
            else $error(
                "State 4: expected 4 PEs, got %0d",
                active_pe_count
            );


        // ------------------------------------------------
        // State 8
        // Expected action = 2
        // Expected PE count = 8
        // ------------------------------------------------

        state = 4'd8;

        #10;

        assert(action == 2'd2)
            else $error(
                "State 8: expected action 2, got %0d",
                action
            );

        assert(active_pe_count == 4'd8)
            else $error(
                "State 8: expected 8 PEs, got %0d",
                active_pe_count
            );


        $display("-----------------------------------------");
        $display("RL ACTION SELECTION TEST PASSED");
        $display("State 0 -> Action 0 -> 2 PEs");
        $display("State 4 -> Action 1 -> 4 PEs");
        $display("State 8 -> Action 2 -> 8 PEs");
        $display("-----------------------------------------");

        $finish;

    end

endmodule
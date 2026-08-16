`timescale 1ns / 1ps

module tb_ras_rl_policy;

    logic [3:0] state;
    logic [1:0] action;
    logic [3:0] active_pe_count;

    // DUT
    ras_rl_policy dut (
        .state(state),
        .action(action),
        .active_pe_count(active_pe_count)
    );

    initial begin

        $display("==============================================");
        $display(" RISC-V RL POLICY TEST");
        $display("==============================================");

        // State 0
        state = 4'd0;
        #10;
        $display("State %0d -> Action %0d -> %0d PEs",
                 state, action, active_pe_count);

        // State 1
        state = 4'd1;
        #10;
        $display("State %0d -> Action %0d -> %0d PEs",
                 state, action, active_pe_count);

        // State 2
        state = 4'd2;
        #10;
        $display("State %0d -> Action %0d -> %0d PEs",
                 state, action, active_pe_count);

        // State 3
        state = 4'd3;
        #10;
        $display("State %0d -> Action %0d -> %0d PEs",
                 state, action, active_pe_count);

        // State 4
        state = 4'd4;
        #10;
        $display("State %0d -> Action %0d -> %0d PEs",
                 state, action, active_pe_count);

        // State 5
        state = 4'd5;
        #10;
        $display("State %0d -> Action %0d -> %0d PEs",
                 state, action, active_pe_count);

        // State 6
        state = 4'd6;
        #10;
        $display("State %0d -> Action %0d -> %0d PEs",
                 state, action, active_pe_count);

        // State 7
        state = 4'd7;
        #10;
        $display("State %0d -> Action %0d -> %0d PEs",
                 state, action, active_pe_count);

        // State 8
        state = 4'd8;
        #10;
        $display("State %0d -> Action %0d -> %0d PEs",
                 state, action, active_pe_count);

        $display("==============================================");
        $display(" POLICY TEST COMPLETED");
        $display("==============================================");

        $finish;

    end

endmodule
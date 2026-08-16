`timescale 1ns/1ps

module ras_pe_array_tb;

    localparam integer MAX_PES = 8;

    logic clk;
    logic rst;

    logic enable;
    logic clear;

    logic [3:0] active_pe_count;

    logic [MAX_PES*16-1:0] data_a_bus;
    logic [MAX_PES*16-1:0] data_b_bus;

    logic [MAX_PES*32-1:0] pe_outputs;

    ras_pe_array #(
        .MAX_PES(MAX_PES)
    ) dut (
        .clk(clk),
        .rst(rst),

        .enable(enable),
        .clear(clear),

        .active_pe_count(active_pe_count),

        .data_a_bus(data_a_bus),
        .data_b_bus(data_b_bus),

        .pe_outputs(pe_outputs)
    );

    always #5 clk = ~clk;


    initial begin

        clk = 1'b0;
        rst = 1'b1;

        enable = 1'b0;
        clear = 1'b0;

        active_pe_count = 4'd0;

        data_a_bus = '0;
        data_b_bus = '0;

        // ------------------------------------------------
        // Reset
        // ------------------------------------------------

        #12;
        rst = 1'b0;


        // ------------------------------------------------
        // Clear all PEs
        // ------------------------------------------------

        clear = 1'b1;

        @(posedge clk);
        #1;

        clear = 1'b0;


        // ------------------------------------------------
        // Configure inputs
        //
        // PE0 = 2 × 3 = 6
        // PE1 = 3 × 4 = 12
        // PE2 = 4 × 5 = 20
        // PE3 = 5 × 6 = 30
        // ------------------------------------------------

        data_a_bus[0*16 +: 16] = 16'sd2;
        data_b_bus[0*16 +: 16] = 16'sd3;

        data_a_bus[1*16 +: 16] = 16'sd3;
        data_b_bus[1*16 +: 16] = 16'sd4;

        data_a_bus[2*16 +: 16] = 16'sd4;
        data_b_bus[2*16 +: 16] = 16'sd5;

        data_a_bus[3*16 +: 16] = 16'sd5;
        data_b_bus[3*16 +: 16] = 16'sd6;


        // ------------------------------------------------
        // Test 2 active PEs
        // ------------------------------------------------

        active_pe_count = 4'd2;
        enable = 1'b1;

        @(posedge clk);
        #1;

        assert(pe_outputs[0*32 +: 32] == 32'sd6)
            else $error("PE0 incorrect");

        assert(pe_outputs[1*32 +: 32] == 32'sd12)
            else $error("PE1 incorrect");

        assert(pe_outputs[2*32 +: 32] == 32'sd0)
            else $error("PE2 should be inactive");

        assert(pe_outputs[3*32 +: 32] == 32'sd0)
            else $error("PE3 should be inactive");


        // ------------------------------------------------
        // Clear and test 4 active PEs
        // ------------------------------------------------

        enable = 1'b0;
        clear = 1'b1;

        @(posedge clk);
        #1;

        clear = 1'b0;

        active_pe_count = 4'd4;
        enable = 1'b1;

        @(posedge clk);
        #1;

        assert(pe_outputs[0*32 +: 32] == 32'sd6)
            else $error("PE0 incorrect in 4-PE mode");

        assert(pe_outputs[1*32 +: 32] == 32'sd12)
            else $error("PE1 incorrect in 4-PE mode");

        assert(pe_outputs[2*32 +: 32] == 32'sd20)
            else $error("PE2 incorrect in 4-PE mode");

        assert(pe_outputs[3*32 +: 32] == 32'sd30)
            else $error("PE3 incorrect in 4-PE mode");

        assert(pe_outputs[4*32 +: 32] == 32'sd0)
            else $error("PE4 should be inactive");


        // ------------------------------------------------
        // Clear and test 8 active PEs
        // ------------------------------------------------

        enable = 1'b0;
        clear = 1'b1;

        @(posedge clk);
        #1;

        clear = 1'b0;

        active_pe_count = 4'd8;
        enable = 1'b1;

        @(posedge clk);
        #1;

        assert(pe_outputs[0*32 +: 32] == 32'sd6);
        assert(pe_outputs[1*32 +: 32] == 32'sd12);
        assert(pe_outputs[2*32 +: 32] == 32'sd20);
        assert(pe_outputs[3*32 +: 32] == 32'sd30);


        $display("--------------------------------");
        $display("PE ARRAY TEST PASSED");
        $display("Active PEs = %0d", active_pe_count);
        $display("PE0 = %0d",
                 $signed(pe_outputs[0*32 +: 32]));
        $display("PE1 = %0d",
                 $signed(pe_outputs[1*32 +: 32]));
        $display("PE2 = %0d",
                 $signed(pe_outputs[2*32 +: 32]));
        $display("PE3 = %0d",
                 $signed(pe_outputs[3*32 +: 32]));
        $display("--------------------------------");

        $finish;

    end

endmodule
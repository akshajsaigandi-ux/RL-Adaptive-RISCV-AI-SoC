`timescale 1ns/1ps

module ras_pe_array_controller_tb;

    logic clk;
    logic rst;

    logic [3:0] active_pe_count;
    logic enable;

    logic [7:0] pe_enable;


    ras_pe_array_controller dut (

        .clk(clk),
        .rst(rst),

        .active_pe_count(active_pe_count),
        .enable(enable),

        .pe_enable(pe_enable)

    );


    always #5 clk = ~clk;


    initial begin

        clk = 1'b0;
        rst = 1'b1;

        enable = 1'b0;
        active_pe_count = 4'd0;

        #12;

        rst = 1'b0;


        // ==========================================
        // Test 1: Disabled
        // ==========================================

        enable = 1'b0;
        active_pe_count = 4'd8;

        #10;

        assert(pe_enable == 8'b00000000)
            else $error(
                "Disable test failed"
            );


        // ==========================================
        // Test 2: 2 PEs
        // ==========================================

        enable = 1'b1;
        active_pe_count = 4'd2;

        #10;

        assert(pe_enable == 8'b00000011)
            else $error(
                "2 PE configuration failed"
            );


        // ==========================================
        // Test 3: 4 PEs
        // ==========================================

        active_pe_count = 4'd4;

        #10;

        assert(pe_enable == 8'b00001111)
            else $error(
                "4 PE configuration failed"
            );


        // ==========================================
        // Test 4: 8 PEs
        // ==========================================

        active_pe_count = 4'd8;

        #10;

        assert(pe_enable == 8'b11111111)
            else $error(
                "8 PE configuration failed"
            );


        // ==========================================
        // Test 5: Invalid value
        // ==========================================

        active_pe_count = 4'd6;

        #10;

        assert(pe_enable == 8'b00000011)
            else $error(
                "Safety default failed"
            );


        $display("--------------------------------");
        $display("PE ARRAY CONTROLLER TEST PASSED");
        $display("--------------------------------");

        $finish;

    end

endmodule
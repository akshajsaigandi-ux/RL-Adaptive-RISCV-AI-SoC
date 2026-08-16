`timescale 1ns/1ps

module ras_mac_unit_tb;

    logic clk;
    logic rst;
    logic enable;
    logic clear;

    logic signed [15:0] data_a;
    logic signed [15:0] data_b;

    logic signed [31:0] accumulator;

    ras_mac_unit dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .clear(clear),
        .data_a(data_a),
        .data_b(data_b),
        .accumulator(accumulator)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;
        rst = 1'b1;
        enable = 1'b0;
        clear = 1'b0;

        data_a = 16'sd0;
        data_b = 16'sd0;

        // Reset
        #12;
        rst = 1'b0;

        // Clear accumulator
        clear = 1'b1;
        @(posedge clk);
        #1;
        clear = 1'b0;

        // 2 × 3 = 6
        data_a = 16'sd2;
        data_b = 16'sd3;
        enable = 1'b1;

        @(posedge clk);
        #1;

        assert(accumulator == 32'sd6)
            else $error("MAC error: expected 6, got %0d",
                        accumulator);

        // 4 × 5 = 20
        data_a = 16'sd4;
        data_b = 16'sd5;

        @(posedge clk);
        #1;

        assert(accumulator == 32'sd26)
            else $error("MAC error: expected 26, got %0d",
                        accumulator);

        // Negative test
        // 3 × -2 = -6
        data_a = 16'sd3;
        data_b = -16'sd2;

        @(posedge clk);
        #1;

        assert(accumulator == 32'sd20)
            else $error("MAC error: expected 20, got %0d",
                        accumulator);

        enable = 1'b0;

        $display("MAC UNIT TEST PASSED");
        $finish;

    end

endmodule
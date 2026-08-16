`timescale 1ns/1ps

module ras_processing_element_tb;

    logic clk;
    logic rst;
    logic enable;
    logic clear;

    logic signed [15:0] data_a;
    logic signed [15:0] data_b;

    logic signed [31:0] pe_output;

    ras_processing_element dut (
        .clk      (clk),
        .rst      (rst),
        .enable   (enable),
        .clear    (clear),
        .data_a   (data_a),
        .data_b   (data_b),
        .pe_output(pe_output)
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

        // Clear
        clear = 1'b1;
        @(posedge clk);
        #1;
        clear = 1'b0;

        // 2 × 3
        data_a = 16'sd2;
        data_b = 16'sd3;
        enable = 1'b1;

        @(posedge clk);
        #1;

        assert(pe_output == 32'sd6)
            else $error("PE output expected 6, got %0d",
                        pe_output);

        // 4 × 5
        data_a = 16'sd4;
        data_b = 16'sd5;

        @(posedge clk);
        #1;

        assert(pe_output == 32'sd26)
            else $error("PE output expected 26, got %0d",
                        pe_output);

        // Disable
        enable = 1'b0;

        @(posedge clk);
        #1;

        assert(pe_output == 32'sd26)
            else $error("PE changed while disabled");

        $display("PROCESSING ELEMENT TEST PASSED");

        $finish;

    end

endmodule
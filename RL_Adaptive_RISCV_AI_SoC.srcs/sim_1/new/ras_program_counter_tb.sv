`timescale 1ns/1ps

module ras_program_counter_tb;

    logic        clk;
    logic        rst;
    logic        pc_enable;
    logic [31:0] pc_next;
    logic [31:0] pc;

    ras_program_counter dut (
        .clk(clk),
        .rst(rst),
        .pc_enable(pc_enable),
        .pc_next(pc_next),
        .pc(pc)
    );

    // 100 MHz equivalent simulation clock
    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;
        rst = 1'b1;
        pc_enable = 1'b0;
        pc_next = 32'd0;

        // Reset
        #12;

        rst = 1'b0;
        pc_enable = 1'b1;

        // PC = 4
        pc_next = 32'd4;
        @(posedge clk);
        #1;
        assert(pc == 32'd4)
            else $error("PC failed: expected 4, got %0d", pc);

        // PC = 8
        pc_next = 32'd8;
        @(posedge clk);
        #1;
        assert(pc == 32'd8)
            else $error("PC failed: expected 8, got %0d", pc);

        // PC = 12
        pc_next = 32'd12;
        @(posedge clk);
        #1;
        assert(pc == 32'd12)
            else $error("PC failed: expected 12, got %0d", pc);

        // Test enable = 0
        pc_enable = 1'b0;
        pc_next = 32'd100;
        @(posedge clk);
        #1;

        assert(pc == 32'd12)
            else $error("PC changed while disabled");

        $display("PROGRAM COUNTER TEST PASSED");

        $finish;

    end

endmodule
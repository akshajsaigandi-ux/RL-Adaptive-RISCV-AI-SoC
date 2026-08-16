`timescale 1ns / 1ps

module tb_ras_riscv_core;

    // ========================================================
    // Clock and reset
    // ========================================================

    logic clk;
    logic rst;


    // ========================================================
    // Debug signals
    // ========================================================

    logic [31:0] debug_pc;
    logic [31:0] debug_instruction;

    logic [31:0] debug_x1;
    logic [31:0] debug_x2;
    logic [31:0] debug_x3;

    logic [31:0] debug_mem0;


    // ========================================================
    // DUT
    // ========================================================

    ras_riscv_core dut (

        .clk(clk),
        .rst(rst),

        .debug_pc(debug_pc),
        .debug_instruction(debug_instruction),

        .debug_x1(debug_x1),
        .debug_x2(debug_x2),
        .debug_x3(debug_x3),

        .debug_mem0(debug_mem0)

    );


    // ========================================================
    // Clock
    // 10 ns period
    // ========================================================

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    // ========================================================
    // Reset and simulation
    // ========================================================

    initial begin

        rst = 1'b1;

        // Hold reset
        #20;

        rst = 1'b0;

        // Run processor
        #300;

        $finish;

    end


    // ========================================================
    // Monitor
    // ========================================================

    initial begin

        $monitor(
            "TIME=%0t | PC=%h | INSTR=%h | X1=%0d | X2=%0d | X3=%0d | MEM0=%0d",
            $time,
            debug_pc,
            debug_instruction,
            debug_x1,
            debug_x2,
            debug_x3,
            debug_mem0
        );

    end

endmodule
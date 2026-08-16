`timescale 1ns / 1ps

// ============================================================
// RL Adaptive RISC-V AI SoC
//
// Instruction Memory
//
// Function:
//   - Stores the RISC-V test program
//   - Provides instruction based on PC address
//   - Includes custom-0 instruction to trigger
//     the RL adaptive accelerator
// ============================================================

module ras_instruction_memory #(
    parameter integer DEPTH = 256
)(
    input  logic [31:0] address,
    output logic [31:0] instruction
);

    // ========================================================
    // Instruction Memory Array
    // ========================================================

    logic [31:0] memory [0:DEPTH-1];

    integer i;

    // ========================================================
    // Initialize Instruction Memory
    // ========================================================

    initial begin

        // ----------------------------------------------------
        // Initialize entire memory with NOP
        //
        // NOP = ADDI x0, x0, 0
        // ----------------------------------------------------

        for (i = 0; i < DEPTH; i = i + 1)
            memory[i] = 32'h00000013;


        // ====================================================
        // RISC-V Test Program
        // ====================================================

        // ----------------------------------------------------
        // Instruction 0
        // PC = 0x00
        //
        // ADDI x1, x0, 5
        //
        // x1 = 5
        // ----------------------------------------------------

        memory[0] = 32'h00500093;


        // ----------------------------------------------------
        // Instruction 1
        // PC = 0x04
        //
        // ADDI x2, x0, 10
        //
        // x2 = 10
        // ----------------------------------------------------

        memory[1] = 32'h00A00113;


        // ----------------------------------------------------
        // Instruction 2
        // PC = 0x08
        //
        // ADD x3, x1, x2
        //
        // x3 = x1 + x2
        // x3 = 5 + 10 = 15
        // ----------------------------------------------------

        memory[2] = 32'h002081B3;


        // ----------------------------------------------------
        // Instruction 3
        // PC = 0x0C
        //
        // SW x3, 0(x0)
        //
        // Store x3 into data memory address 0
        // ----------------------------------------------------

        memory[3] = 32'h00302023;


        // ----------------------------------------------------
        // Instruction 4
        // PC = 0x10
        //
        // CUSTOM-0 instruction
        //
        // Opcode = 0001011
        //
        // This instruction will later be decoded as:
        //
        // "Start RL Adaptive Accelerator"
        // ----------------------------------------------------

        memory[4] = 32'h0000000B;


        // ----------------------------------------------------
        // Instruction 5
        // PC = 0x14
        //
        // NOP
        // ----------------------------------------------------

        memory[5] = 32'h00000013;

    end


    // ========================================================
    // Instruction Read
    // ========================================================
    //
    // RISC-V instructions are 32-bit aligned.
    //
    // address[31:2] removes the two least-significant bits
    // and converts the byte address into a word index.
    //
    // Example:
    //
    // PC = 0x00 -> memory[0]
    // PC = 0x04 -> memory[1]
    // PC = 0x08 -> memory[2]
    // PC = 0x0C -> memory[3]
    // PC = 0x10 -> memory[4]
    //
    // ========================================================

    always_comb begin

        if (address[31:2] < DEPTH)

            instruction = memory[address[31:2]];

        else

            instruction = 32'h00000013;   // NOP

    end

endmodule
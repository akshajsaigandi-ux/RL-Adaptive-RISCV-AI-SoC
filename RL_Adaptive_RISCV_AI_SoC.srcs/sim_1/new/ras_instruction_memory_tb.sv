`timescale 1ns/1ps

module ras_instruction_memory_tb;

    logic [31:0] address;
    logic [31:0] instruction;

    ras_instruction_memory dut (
        .address(address),
        .instruction(instruction)
    );

    initial begin

        // Instruction 0
        address = 32'd0;
        #10;

        assert(instruction == 32'h00500093)
            else $error("Instruction 0 incorrect");

        // Instruction 1
        address = 32'd4;
        #10;

        assert(instruction == 32'h00A00113)
            else $error("Instruction 1 incorrect");

        // Instruction 2
        address = 32'd8;
        #10;

        assert(instruction == 32'h002081B3)
            else $error("Instruction 2 incorrect");

        // Instruction 3
        address = 32'd12;
        #10;

        assert(instruction == 32'h00302023)
            else $error("Instruction 3 incorrect");

        // NOP
        address = 32'd16;
        #10;

        assert(instruction == 32'h00000013)
            else $error("NOP incorrect");

        $display("INSTRUCTION MEMORY TEST PASSED");

        $finish;

    end

endmodule
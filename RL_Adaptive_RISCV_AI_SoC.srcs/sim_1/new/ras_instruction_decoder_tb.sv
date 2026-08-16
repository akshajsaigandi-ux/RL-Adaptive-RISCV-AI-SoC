`timescale 1ns/1ps

module ras_instruction_decoder_tb;

    logic [31:0] instruction;

    logic [6:0]  opcode;
    logic [4:0]  rd;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [2:0]  funct3;
    logic [6:0]  funct7;
    logic [31:0] immediate;

    ras_instruction_decoder dut (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .funct3(funct3),
        .funct7(funct7),
        .immediate(immediate)
    );

    initial begin

        // ADDI x1, x0, 5
        instruction = 32'h00500093;
        #10;

        assert(opcode == 7'b0010011)
            else $error("ADDI opcode incorrect");

        assert(rd == 5'd1)
            else $error("ADDI rd incorrect");

        assert(rs1 == 5'd0)
            else $error("ADDI rs1 incorrect");

        assert(immediate == 32'd5)
            else $error("ADDI immediate incorrect");

        // ADD x3, x1, x2
        instruction = 32'h002081B3;
        #10;

        assert(opcode == 7'b0110011)
            else $error("ADD opcode incorrect");

        assert(rd == 5'd3)
            else $error("ADD rd incorrect");

        assert(rs1 == 5'd1)
            else $error("ADD rs1 incorrect");

        assert(rs2 == 5'd2)
            else $error("ADD rs2 incorrect");

        assert(funct3 == 3'b000)
            else $error("ADD funct3 incorrect");

        assert(funct7 == 7'b0000000)
            else $error("ADD funct7 incorrect");

        // SW x3, 0(x0)
        instruction = 32'h00302023;
        #10;

        assert(opcode == 7'b0100011)
            else $error("SW opcode incorrect");

        assert(rs1 == 5'd0)
            else $error("SW rs1 incorrect");

        assert(rs2 == 5'd3)
            else $error("SW rs2 incorrect");

        assert(immediate == 32'd0)
            else $error("SW immediate incorrect");

        $display("INSTRUCTION DECODER TEST PASSED");

        $finish;

    end

endmodule
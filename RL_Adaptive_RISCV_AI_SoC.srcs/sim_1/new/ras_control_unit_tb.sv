`timescale 1ns/1ps

module ras_control_unit_tb;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    logic       reg_write;
    logic       alu_src;
    logic       mem_write;
    logic       mem_read;
    logic       mem_to_reg;
    logic       branch;
    logic       branch_ne;
    logic       jump;
    logic [3:0] alu_control;

    ras_control_unit dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .branch_ne(branch_ne),
        .jump(jump),
        .alu_control(alu_control)
    );

    initial begin

        // --------------------------------------------
        // ADD
        // --------------------------------------------
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;

        #10;

        assert(reg_write == 1'b1);
        assert(alu_src == 1'b0);
        assert(alu_control == 4'b0000);

        // --------------------------------------------
        // SUB
        // --------------------------------------------
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0100000;

        #10;

        assert(reg_write == 1'b1);
        assert(alu_control == 4'b0001);

        // --------------------------------------------
        // ADDI
        // --------------------------------------------
        opcode = 7'b0010011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;

        #10;

        assert(reg_write == 1'b1);
        assert(alu_src == 1'b1);
        assert(alu_control == 4'b0000);

        // --------------------------------------------
        // LW
        // --------------------------------------------
        opcode = 7'b0000011;
        funct3 = 3'b010;
        funct7 = 7'b0000000;

        #10;

        assert(reg_write == 1'b1);
        assert(alu_src == 1'b1);
        assert(mem_read == 1'b1);
        assert(mem_to_reg == 1'b1);

        // --------------------------------------------
        // SW
        // --------------------------------------------
        opcode = 7'b0100011;
        funct3 = 3'b010;
        funct7 = 7'b0000000;

        #10;

        assert(reg_write == 1'b0);
        assert(alu_src == 1'b1);
        assert(mem_write == 1'b1);

        // --------------------------------------------
        // BEQ
        // --------------------------------------------
        opcode = 7'b1100011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;

        #10;

        assert(branch == 1'b1);
        assert(branch_ne == 1'b0);
        assert(alu_control == 4'b0001);

        // --------------------------------------------
        // BNE
        // --------------------------------------------
        opcode = 7'b1100011;
        funct3 = 3'b001;
        funct7 = 7'b0000000;

        #10;

        assert(branch == 1'b1);
        assert(branch_ne == 1'b1);
        assert(alu_control == 4'b0001);

        // --------------------------------------------
        // JAL
        // --------------------------------------------
        opcode = 7'b1101111;
        funct3 = 3'b000;
        funct7 = 7'b0000000;

        #10;

        assert(jump == 1'b1);
        assert(reg_write == 1'b1);

        $display("CONTROL UNIT TEST PASSED");

        $finish;

    end

endmodule
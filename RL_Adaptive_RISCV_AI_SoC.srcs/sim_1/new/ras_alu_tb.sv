`timescale 1ns/1ps

module ras_alu_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic [3:0]  alu_control;
    logic [31:0] result;
    logic        zero;

    ras_alu dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    initial begin

        a = 32'd10;
        b = 32'd5;
        alu_control = 4'b0000; // ADD
        #10;
        assert(result == 32'd15);

        a = 32'd10;
        b = 32'd5;
        alu_control = 4'b0001; // SUB
        #10;
        assert(result == 32'd5);

        a = 32'hFF00FF00;
        b = 32'h0F0F0F0F;
        alu_control = 4'b0010; // AND
        #10;
        assert(result == 32'h0F000F00);

        alu_control = 4'b0011; // OR
        #10;
        assert(result == 32'hFF0FFF0F);

        alu_control = 4'b0100; // XOR
        #10;
        assert(result == 32'hF00FF00F);

        a = 32'd5;
        b = 32'd10;
        alu_control = 4'b0101; // SLT
        #10;
        assert(result == 32'd1);

        a = 32'd1;
        b = 32'd4;
        alu_control = 4'b0110; // SLL
        #10;
        assert(result == 32'd16);

        a = 32'd16;
        b = 32'd2;
        alu_control = 4'b0111; // SRL
        #10;
        assert(result == 32'd4);

        $display("ALU TEST PASSED");
        $finish;

    end

endmodule
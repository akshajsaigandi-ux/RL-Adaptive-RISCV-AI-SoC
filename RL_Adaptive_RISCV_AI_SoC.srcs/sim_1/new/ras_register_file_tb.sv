`timescale 1ns/1ps

module ras_register_file_tb;

    logic clk;
    logic rst;

    logic [4:0] rs1_addr;
    logic [4:0] rs2_addr;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;

    logic rd_write_enable;
    logic [4:0] rd_addr;
    logic [31:0] rd_data;

    ras_register_file dut (
        .clk(clk),
        .rst(rst),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .rd_write_enable(rd_write_enable),
        .rd_addr(rd_addr),
        .rd_data(rd_data)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;
        rst = 1'b1;

        rs1_addr = 5'd0;
        rs2_addr = 5'd0;
        rd_write_enable = 1'b0;
        rd_addr = 5'd0;
        rd_data = 32'd0;

        #12;

        rst = 1'b0;

        // Write x1 = 100
        @(negedge clk);
        rd_write_enable = 1'b1;
        rd_addr = 5'd1;
        rd_data = 32'd100;

        @(negedge clk);
        rd_write_enable = 1'b0;

        // Write x2 = 200
        @(negedge clk);
        rd_write_enable = 1'b1;
        rd_addr = 5'd2;
        rd_data = 32'd200;

        @(negedge clk);
        rd_write_enable = 1'b0;

        // Read x1 and x2
        rs1_addr = 5'd1;
        rs2_addr = 5'd2;

        #2;

        assert(rs1_data == 32'd100);
        assert(rs2_data == 32'd200);

        // Verify x0 is always zero
        rs1_addr = 5'd0;
        #2;

        assert(rs1_data == 32'd0);

        $display("REGISTER FILE TEST PASSED");
        $finish;

    end

endmodule
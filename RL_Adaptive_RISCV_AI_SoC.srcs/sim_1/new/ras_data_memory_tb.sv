`timescale 1ns/1ps

module ras_data_memory_tb;

    logic        clk;
    logic        rst;

    logic        mem_read;
    logic        mem_write;

    logic [31:0] address;
    logic [31:0] write_data;
    logic [31:0] read_data;

    ras_data_memory dut (
        .clk(clk),
        .rst(rst),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;
        rst = 1'b1;

        mem_read = 1'b0;
        mem_write = 1'b0;
        address = 32'd0;
        write_data = 32'd0;

        // Reset memory
        #12;
        rst = 1'b0;

        // Write 15 to address 0
        @(negedge clk);

        mem_write = 1'b1;
        address = 32'd0;
        write_data = 32'd15;

        @(negedge clk);

        mem_write = 1'b0;

        // Read address 0
        mem_read = 1'b1;
        address = 32'd0;

        #2;

        assert(read_data == 32'd15)
            else $error(
                "Memory read failed: expected 15, got %0d",
                read_data
            );

        // Write another value to address 4
        @(negedge clk);

        mem_read = 1'b0;
        mem_write = 1'b1;
        address = 32'd4;
        write_data = 32'd123;

        @(negedge clk);

        mem_write = 1'b0;

        // Read address 4
        mem_read = 1'b1;
        address = 32'd4;

        #2;

        assert(read_data == 32'd123)
            else $error(
                "Memory read failed: expected 123, got %0d",
                read_data
            );

        $display("DATA MEMORY TEST PASSED");

        $finish;

    end

endmodule
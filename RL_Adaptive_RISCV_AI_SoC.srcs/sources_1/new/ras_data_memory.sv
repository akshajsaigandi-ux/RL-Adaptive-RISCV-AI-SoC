module ras_data_memory #(
    parameter integer DEPTH = 256
)(
    input  logic        clk,
    input  logic        rst,

    input  logic        mem_read,
    input  logic        mem_write,

    input  logic [31:0] address,
    input  logic [31:0] write_data,

    output logic [31:0] read_data
);

    logic [31:0] memory [0:DEPTH-1];

    integer i;

    // Initialize memory
    always_ff @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < DEPTH; i = i + 1)
                memory[i] <= 32'd0;
        end
        else if (mem_write) begin
            if (address[31:2] < DEPTH)
                memory[address[31:2]] <= write_data;
        end
    end

    // Combinational read
    always_comb begin
        if (mem_read && (address[31:2] < DEPTH))
            read_data = memory[address[31:2]];
        else
            read_data = 32'd0;
    end

endmodule
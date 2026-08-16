module ras_register_file (
    input  logic        clk,
    input  logic        rst,

    input  logic [4:0]  rs1_addr,
    input  logic [4:0]  rs2_addr,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,

    input  logic        rd_write_enable,
    input  logic [4:0]  rd_addr,
    input  logic [31:0] rd_data
);

    logic [31:0] registers [0:31];

    integer i;

    always_ff @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;
        end
        else if (rd_write_enable && (rd_addr != 5'd0)) begin
            registers[rd_addr] <= rd_data;
        end
    end

    always_comb begin
        if (rs1_addr == 5'd0)
            rs1_data = 32'd0;
        else
            rs1_data = registers[rs1_addr];

        if (rs2_addr == 5'd0)
            rs2_data = 32'd0;
        else
            rs2_data = registers[rs2_addr];
    end

endmodule
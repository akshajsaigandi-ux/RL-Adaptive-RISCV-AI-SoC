module ras_program_counter (
    input  logic        clk,
    input  logic        rst,
    input  logic        pc_enable,
    input  logic [31:0] pc_next,

    output logic [31:0] pc
);

    always_ff @(posedge clk) begin
        if (rst)
            pc <= 32'h0000_0000;
        else if (pc_enable)
            pc <= pc_next;
    end

endmodule
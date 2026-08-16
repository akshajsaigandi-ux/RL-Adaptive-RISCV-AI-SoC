module ras_mac_unit (
    input  logic        clk,
    input  logic        rst,
    input  logic        enable,
    input  logic        clear,

    input  logic signed [15:0] data_a,
    input  logic signed [15:0] data_b,

    output logic signed [31:0] accumulator
);

    //==================================================
    // Pipeline Registers
    //==================================================

    logic signed [15:0] data_a_reg;
    logic signed [15:0] data_b_reg;

    logic               enable_reg;

    logic signed [31:0] product_reg;

    //==================================================
    // Stage 1
    // Register inputs
    //==================================================

    always_ff @(posedge clk) begin

        if (rst) begin
            data_a_reg <= 16'sd0;
            data_b_reg <= 16'sd0;
            enable_reg <= 1'b0;
        end
        else begin
            data_a_reg <= data_a;
            data_b_reg <= data_b;
            enable_reg <= enable;
        end

    end

    //==================================================
    // Stage 2
    // Registered multiplier
    //==================================================

    always_ff @(posedge clk) begin

        if (rst)
            product_reg <= 32'sd0;
        else
            product_reg <= data_a_reg * data_b_reg;

    end

    //==================================================
    // Stage 3
    // Accumulator
    //==================================================

    always_ff @(posedge clk) begin

        if (rst)
            accumulator <= 32'sd0;

        else if (clear)
            accumulator <= 32'sd0;

        else if (enable_reg)
            accumulator <= accumulator + product_reg;

    end

endmodule
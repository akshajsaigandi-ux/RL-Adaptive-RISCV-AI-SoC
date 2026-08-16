module ras_processing_element (
    input  logic        clk,
    input  logic        rst,

    input  logic        enable,
    input  logic        clear,

    input  logic signed [15:0] data_a,
    input  logic signed [15:0] data_b,

    output logic signed [31:0] pe_output
);

    ras_mac_unit mac_unit (
        .clk        (clk),
        .rst        (rst),
        .enable     (enable),
        .clear      (clear),
        .data_a     (data_a),
        .data_b     (data_b),
        .accumulator(pe_output)
    );

endmodule  
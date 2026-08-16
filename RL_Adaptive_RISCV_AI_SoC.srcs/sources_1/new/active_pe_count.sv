module ras_pe_array #(
    parameter integer MAX_PES = 8
)(
    input  logic clk,
    input  logic rst,

    input  logic enable,
    input  logic clear,

    input  logic [3:0] active_pe_count,

    input  logic [MAX_PES*16-1:0] data_a_bus,
    input  logic [MAX_PES*16-1:0] data_b_bus,

    output logic [MAX_PES*32-1:0] pe_outputs
);

    genvar i;

    generate

        for (i = 0; i < MAX_PES; i = i + 1) begin : PE_GENERATE

            logic pe_enable;

            assign pe_enable =
                enable && (active_pe_count > i);

            ras_processing_element pe_inst (
                .clk(clk),
                .rst(rst),

                .enable(pe_enable),
                .clear(clear),

                .data_a(data_a_bus[i*16 +: 16]),
                .data_b(data_b_bus[i*16 +: 16]),

                .pe_output(pe_outputs[i*32 +: 32])
            );

        end

    endgenerate

endmodule
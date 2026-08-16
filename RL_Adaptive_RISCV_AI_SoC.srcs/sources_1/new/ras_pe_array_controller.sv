module ras_pe_array_controller (

    input  logic        clk,
    input  logic        rst,

    // RL-selected number of active PEs
    input  logic [3:0]  active_pe_count,

    // Global enable
    input  logic        enable,

    // Individual PE enables
    output logic [7:0] pe_enable

);

    always_comb begin

        // Default: all disabled
        pe_enable = 8'b00000000;

        if (enable) begin

            case (active_pe_count)

                // -----------------------------------------
                // 2 active PEs
                // -----------------------------------------
                4'd2:
                    pe_enable = 8'b00000011;

                // -----------------------------------------
                // 4 active PEs
                // -----------------------------------------
                4'd4:
                    pe_enable = 8'b00001111;

                // -----------------------------------------
                // 8 active PEs
                // -----------------------------------------
                4'd8:
                    pe_enable = 8'b11111111;

                // -----------------------------------------
                // Safety default
                // -----------------------------------------
                default:
                    pe_enable = 8'b00000011;

            endcase

        end

    end

endmodule
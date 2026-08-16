`timescale 1ns / 1ps

// ============================================================
// RL Adaptive RISC-V AI SoC
//
// Instruction Decoder
//
// Supports:
//   - R-type
//   - I-type / ADDI
//   - Load
//   - Store
//   - Branch
//   - JAL
//   - Custom-0 RL Accelerator instruction
// ============================================================

module ras_instruction_decoder (
    input  logic [31:0] instruction,

    output logic [6:0]  opcode,
    output logic [4:0]  rd,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [2:0]  funct3,
    output logic [6:0]  funct7,

    output logic [31:0] immediate,

    // RL Adaptive Accelerator instruction
    output logic        accelerator_enable
);


    // ========================================================
    // Opcode definitions
    // ========================================================

    localparam logic [6:0] OPCODE_CUSTOM0 = 7'b0001011;


    // ========================================================
    // Instruction decoding
    // ========================================================

    always_comb begin

        // ----------------------------------------------------
        // Common instruction fields
        // ----------------------------------------------------

        opcode = instruction[6:0];

        rd     = instruction[11:7];

        funct3 = instruction[14:12];

        rs1    = instruction[19:15];

        rs2    = instruction[24:20];

        funct7 = instruction[31:25];


        // ----------------------------------------------------
        // Default values
        // ----------------------------------------------------

        immediate = 32'd0;

        accelerator_enable = 1'b0;


        // ====================================================
        // Immediate generation
        // ====================================================

        case (instruction[6:0])


            // ------------------------------------------------
            // I-type
            //
            // ADDI
            // ------------------------------------------------

            7'b0010011,

            // ------------------------------------------------
            // Load
            //
            // LW
            // ------------------------------------------------

            7'b0000011: begin

                immediate =
                    {{20{instruction[31]}},
                     instruction[31:20]};

            end


            // ------------------------------------------------
            // S-type
            //
            // SW
            // ------------------------------------------------

            7'b0100011: begin

                immediate =
                    {{20{instruction[31]}},
                     instruction[31:25],
                     instruction[11:7]};

            end


            // ------------------------------------------------
            // B-type
            //
            // BEQ / BNE
            // ------------------------------------------------

            7'b1100011: begin

                immediate =
                    {{19{instruction[31]}},
                     instruction[31],
                     instruction[7],
                     instruction[30:25],
                     instruction[11:8],
                     1'b0};

            end


            // ------------------------------------------------
            // J-type
            //
            // JAL
            // ------------------------------------------------

            7'b1101111: begin

                immediate =
                    {{11{instruction[31]}},
                     instruction[31],
                     instruction[19:12],
                     instruction[20],
                     instruction[30:21],
                     1'b0};

            end


            // ------------------------------------------------
            // Custom-0
            //
            // RL Adaptive Accelerator
            //
            // 0000000B
            // opcode = 0001011
            // ------------------------------------------------

            OPCODE_CUSTOM0: begin

                immediate = 32'd0;

                accelerator_enable = 1'b1;

            end


            // ------------------------------------------------
            // Default
            // ------------------------------------------------

            default: begin

                immediate = 32'd0;

                accelerator_enable = 1'b0;

            end

        endcase

    end

endmodule
`timescale 1ns / 1ps

// ============================================================
// RL Adaptive RISC-V AI SoC
//
// Control Unit
//
// Supports:
//   - R-type
//   - I-type / ADDI
//   - LW
//   - SW
//   - BEQ
//   - BNE
//   - JAL
//   - Custom-0 RL Adaptive Accelerator
// ============================================================

module ras_control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,

    // RL accelerator instruction
    input  logic       accelerator_enable,

    output logic       reg_write,
    output logic       alu_src,
    output logic       mem_write,
    output logic       mem_read,
    output logic       mem_to_reg,
    output logic       branch,
    output logic       branch_ne,
    output logic       jump,
    output logic [3:0] alu_control,

    // RL accelerator control
    output logic       accelerator_start
);


    // ========================================================
    // Opcode definitions
    // ========================================================

    localparam logic [6:0] OPCODE_R_TYPE = 7'b0110011;
    localparam logic [6:0] OPCODE_I_TYPE = 7'b0010011;
    localparam logic [6:0] OPCODE_LOAD   = 7'b0000011;
    localparam logic [6:0] OPCODE_STORE  = 7'b0100011;
    localparam logic [6:0] OPCODE_BRANCH = 7'b1100011;
    localparam logic [6:0] OPCODE_JAL    = 7'b1101111;
    localparam logic [6:0] OPCODE_CUSTOM0 = 7'b0001011;


    // ========================================================
    // ALU control values
    // ========================================================

    localparam logic [3:0] ALU_ADD = 4'b0000;
    localparam logic [3:0] ALU_SUB = 4'b0001;
    localparam logic [3:0] ALU_AND = 4'b0010;
    localparam logic [3:0] ALU_OR  = 4'b0011;
    localparam logic [3:0] ALU_XOR = 4'b0100;
    localparam logic [3:0] ALU_SLT = 4'b0101;
    localparam logic [3:0] ALU_SLL = 4'b0110;
    localparam logic [3:0] ALU_SRL = 4'b0111;


    // ========================================================
    // Control logic
    // ========================================================

    always_comb begin

        // ----------------------------------------------------
        // Default control values
        // ----------------------------------------------------

        reg_write       = 1'b0;
        alu_src         = 1'b0;
        mem_write       = 1'b0;
        mem_read        = 1'b0;
        mem_to_reg      = 1'b0;
        branch          = 1'b0;
        branch_ne       = 1'b0;
        jump            = 1'b0;

        alu_control     = ALU_ADD;

        accelerator_start = 1'b0;


        // ====================================================
        // Instruction decode
        // ====================================================

        case (opcode)


            // ------------------------------------------------
            // R-type instructions
            // ------------------------------------------------

            OPCODE_R_TYPE: begin

                reg_write = 1'b1;
                alu_src   = 1'b0;

                case (funct3)

                    3'b000: begin

                        if (funct7 == 7'b0100000)
                            alu_control = ALU_SUB;
                        else
                            alu_control = ALU_ADD;

                    end

                    3'b111:
                        alu_control = ALU_AND;

                    3'b110:
                        alu_control = ALU_OR;

                    3'b100:
                        alu_control = ALU_XOR;

                    3'b010:
                        alu_control = ALU_SLT;

                    3'b001:
                        alu_control = ALU_SLL;

                    3'b101:
                        alu_control = ALU_SRL;

                    default:
                        alu_control = ALU_ADD;

                endcase

            end


            // ------------------------------------------------
            // I-type arithmetic
            //
            // ADDI
            // ------------------------------------------------

            OPCODE_I_TYPE: begin

                reg_write = 1'b1;
                alu_src   = 1'b1;

                case (funct3)

                    3'b000:
                        alu_control = ALU_ADD;

                    default:
                        alu_control = ALU_ADD;

                endcase

            end


            // ------------------------------------------------
            // Load
            //
            // LW
            // ------------------------------------------------

            OPCODE_LOAD: begin

                reg_write   = 1'b1;
                alu_src     = 1'b1;
                mem_read    = 1'b1;
                mem_to_reg  = 1'b1;
                alu_control = ALU_ADD;

            end


            // ------------------------------------------------
            // Store
            //
            // SW
            // ------------------------------------------------

            OPCODE_STORE: begin

                alu_src     = 1'b1;
                mem_write   = 1'b1;
                alu_control = ALU_ADD;

            end


            // ------------------------------------------------
            // Branch
            //
            // BEQ / BNE
            // ------------------------------------------------

            OPCODE_BRANCH: begin

                branch = 1'b1;

                case (funct3)

                    3'b000: begin

                        // BEQ
                        branch_ne   = 1'b0;
                        alu_control = ALU_SUB;

                    end

                    3'b001: begin

                        // BNE
                        branch_ne   = 1'b1;
                        alu_control = ALU_SUB;

                    end

                    default: begin

                        branch      = 1'b0;
                        branch_ne   = 1'b0;
                        alu_control = ALU_SUB;

                    end

                endcase

            end


            // ------------------------------------------------
            // JAL
            // ------------------------------------------------

            OPCODE_JAL: begin

                reg_write   = 1'b1;
                jump        = 1'b1;
                alu_control = ALU_ADD;

            end


            // ------------------------------------------------
            // CUSTOM-0
            //
            // RL Adaptive Accelerator
            //
            // Opcode:
            // 0001011
            //
            // Instruction:
            // 32'h0000000B
            // ------------------------------------------------

            OPCODE_CUSTOM0: begin

                // The accelerator instruction does not
                // perform an ALU operation and does not
                // access memory.

                reg_write   = 1'b0;
                alu_src     = 1'b0;
                mem_write   = 1'b0;
                mem_read    = 1'b0;
                mem_to_reg  = 1'b0;
                branch      = 1'b0;
                branch_ne   = 1'b0;
                jump        = 1'b0;

                alu_control = ALU_ADD;

                // Start RL adaptive accelerator
                accelerator_start = accelerator_enable;

            end


            // ------------------------------------------------
            // Unknown instruction
            // ------------------------------------------------

            default: begin

                reg_write   = 1'b0;
                alu_src     = 1'b0;
                mem_write   = 1'b0;
                mem_read    = 1'b0;
                mem_to_reg  = 1'b0;
                branch      = 1'b0;
                branch_ne   = 1'b0;
                jump        = 1'b0;

                alu_control = ALU_ADD;

                accelerator_start = 1'b0;

            end

        endcase

    end

endmodule
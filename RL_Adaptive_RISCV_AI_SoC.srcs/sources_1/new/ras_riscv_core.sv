`timescale 1ns / 1ps

// ============================================================
// RL Adaptive RISC-V AI SoC
//
// RISC-V Core with RL Adaptive Accelerator
//
// Supported instructions:
//   - R-type
//   - ADDI
//   - LW
//   - SW
//   - BEQ
//   - BNE
//   - JAL
//   - CUSTOM-0 : RL accelerator start
// ============================================================

module ras_riscv_core (

    input  logic clk,
    input  logic rst,

    output logic [31:0] debug_pc,
    output logic [31:0] debug_instruction,

    output logic [31:0] debug_x1,
    output logic [31:0] debug_x2,
    output logic [31:0] debug_x3,

    output logic [31:0] debug_mem0

);


// ============================================================
// PC
// ============================================================

logic [31:0] pc;
logic [31:0] pc_next;


// ============================================================
// Instruction
// ============================================================

logic [31:0] instruction;


// ============================================================
// Decoder outputs
// ============================================================

logic [6:0] opcode;
logic [4:0] rd;
logic [4:0] rs1;
logic [4:0] rs2;

logic [2:0] funct3;
logic [6:0] funct7;

logic [31:0] immediate;


// ============================================================
// Accelerator decoder signal
// ============================================================

logic accelerator_enable;


// ============================================================
// Control signals
// ============================================================

logic reg_write;
logic alu_src;

logic mem_write;
logic mem_read;
logic mem_to_reg;

logic branch;
logic branch_ne;
logic jump;

logic [3:0] alu_control;


// ============================================================
// Accelerator control
// ============================================================

logic accelerator_start;


// ============================================================
// Register file
// ============================================================

logic [31:0] rs1_data;
logic [31:0] rs2_data;

logic [31:0] writeback_data;


// ============================================================
// ALU
// ============================================================

logic [31:0] alu_b;
logic [31:0] alu_result;

logic alu_zero;


// ============================================================
// Data memory
// ============================================================

logic [31:0] memory_read_data;


// ============================================================
// PC calculation
// ============================================================

logic branch_taken;


assign branch_taken =
    branch &&
    (
        (branch_ne && !alu_zero) ||
        (!branch_ne && alu_zero)
    );


always_comb begin

    pc_next = pc + 32'd4;


    if (branch_taken)

        pc_next = pc + immediate;


    if (jump)

        pc_next = pc + immediate;

end


// ============================================================
// Program Counter
// ============================================================

ras_program_counter pc_unit (

    .clk       (clk),
    .rst       (rst),

    .pc_enable (1'b1),

    .pc_next   (pc_next),

    .pc        (pc)

);


// ============================================================
// Instruction Memory
// ============================================================

ras_instruction_memory instruction_memory (

    .address     (pc),

    .instruction (instruction)

);


// ============================================================
// Instruction Decoder
// ============================================================

ras_instruction_decoder decoder (

    .instruction (instruction),

    .opcode      (opcode),
    .rd          (rd),
    .rs1         (rs1),
    .rs2         (rs2),

    .funct3      (funct3),
    .funct7      (funct7),

    .immediate   (immediate),

    .accelerator_enable (accelerator_enable)

);


// ============================================================
// Control Unit
// ============================================================

ras_control_unit control_unit (

    .opcode (opcode),
    .funct3 (funct3),
    .funct7 (funct7),

    .accelerator_enable (accelerator_enable),

    .reg_write  (reg_write),
    .alu_src    (alu_src),

    .mem_write  (mem_write),
    .mem_read   (mem_read),
    .mem_to_reg (mem_to_reg),

    .branch     (branch),
    .branch_ne  (branch_ne),
    .jump       (jump),

    .alu_control (alu_control),

    .accelerator_start (accelerator_start)

);


// ============================================================
// Register File
// ============================================================

ras_register_file register_file (

    .clk (clk),
    .rst (rst),

    .rs1_addr (rs1),
    .rs2_addr (rs2),

    .rs1_data (rs1_data),
    .rs2_data (rs2_data),

    .rd_write_enable (reg_write),

    .rd_addr (rd),
    .rd_data (writeback_data)

);


// ============================================================
// ALU input selection
// ============================================================

always_comb begin

    if (alu_src)

        alu_b = immediate;

    else

        alu_b = rs2_data;

end


// ============================================================
// ALU
// ============================================================

ras_alu alu (

    .a (rs1_data),

    .b (alu_b),

    .alu_control (alu_control),

    .result (alu_result),

    .zero (alu_zero)

);


// ============================================================
// Data Memory
// ============================================================

ras_data_memory data_memory (

    .clk (clk),
    .rst (rst),

    .mem_read  (mem_read),
    .mem_write (mem_write),

    .address (alu_result),

    .write_data (rs2_data),

    .read_data (memory_read_data)

);


// ============================================================
// Writeback
// ============================================================

always_comb begin

    if (mem_to_reg)

        writeback_data = memory_read_data;

    else

        writeback_data = alu_result;

end


// ============================================================
// ============================================================
// RL ADAPTIVE ACCELERATOR
// ============================================================
// ============================================================


// ------------------------------------------------------------
// Accelerator parameters
// ------------------------------------------------------------

localparam integer MAX_PES = 8;


// ------------------------------------------------------------
// Accelerator data buses
//
// Simple deterministic test data for the first integration.
// Later these can be connected to registers/memory.
// ------------------------------------------------------------

logic [MAX_PES*16-1:0] accelerator_data_a;
logic [MAX_PES*16-1:0] accelerator_data_b;


// ------------------------------------------------------------
// Accelerator outputs
// ------------------------------------------------------------

logic [MAX_PES*32-1:0] accelerator_pe_outputs;

logic [3:0] accelerator_active_pe_count;

logic [1:0] accelerator_selected_action;

logic [3:0] accelerator_current_state;

logic signed [15:0] accelerator_reward;

logic accelerator_learning_valid;

logic [31:0] accelerator_measured_cycles;

logic [31:0] accelerator_active_pe_cycles;

logic [31:0] accelerator_utilization;

logic accelerator_performance_completed;


// ------------------------------------------------------------
// Test input data
//
// PE 0 : 1 + 10
// PE 1 : 2 + 20
// PE 2 : 3 + 30
// ...
//
// This allows us to see actual PE activity in simulation.
// ------------------------------------------------------------

always_comb begin

    accelerator_data_a[15:0]   = 16'd1;
    accelerator_data_a[31:16]  = 16'd2;
    accelerator_data_a[47:32]  = 16'd3;
    accelerator_data_a[63:48]  = 16'd4;
    accelerator_data_a[79:64]  = 16'd5;
    accelerator_data_a[95:80]  = 16'd6;
    accelerator_data_a[111:96] = 16'd7;
    accelerator_data_a[127:112] = 16'd8;


    accelerator_data_b[15:0]   = 16'd10;
    accelerator_data_b[31:16]  = 16'd20;
    accelerator_data_b[47:32]  = 16'd30;
    accelerator_data_b[63:48]  = 16'd40;
    accelerator_data_b[79:64]  = 16'd50;
    accelerator_data_b[95:80]  = 16'd60;
    accelerator_data_b[111:96] = 16'd70;
    accelerator_data_b[127:112] = 16'd80;

end


// ------------------------------------------------------------
// Adaptive Accelerator
// ------------------------------------------------------------

ras_adaptive_accelerator #(

    .MAX_PES (MAX_PES),

    .COMPUTE_CYCLES (4)

) adaptive_accelerator_inst (

    .clk (clk),

    .rst (rst),

    // Custom RISC-V instruction starts accelerator
    .start (accelerator_start),

    .clear (rst),

    // Initial integration test values
    .cycle_count_in (32'd0),

    .utilization_in (32'd0),

    // PE input buses
    .data_a_bus (accelerator_data_a),

    .data_b_bus (accelerator_data_b),

    // PE outputs
    .pe_outputs (accelerator_pe_outputs),

    // RL decision
    .active_pe_count (accelerator_active_pe_count),

    .selected_action (accelerator_selected_action),

    // RL state/reward
    .current_state (accelerator_current_state),

    .reward (accelerator_reward),

    .learning_valid (accelerator_learning_valid),

    // Performance
    .measured_cycles (accelerator_measured_cycles),

    .active_pe_cycles (accelerator_active_pe_cycles),

    .utilization (accelerator_utilization),

    .performance_completed (accelerator_performance_completed)

);


// ============================================================
// Debug outputs
// ============================================================

assign debug_pc =
    pc;


assign debug_instruction =
    instruction;


assign debug_x1 =
    register_file.registers[1];


assign debug_x2 =
    register_file.registers[2];


assign debug_x3 =
    register_file.registers[3];


assign debug_mem0 =
    data_memory.memory[0];


endmodule
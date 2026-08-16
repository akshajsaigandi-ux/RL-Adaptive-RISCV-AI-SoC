`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// RL Adaptive RISC-V AI SoC
//
// FPGA Top-Level Wrapper
//
// Target:
//   Nexys A7 100T
//
// Function:
//   - Runs the RISC-V core
//   - Runs the RL adaptive accelerator
//   - Periodically starts accelerator operations
//   - RL controller selects 2 / 4 / 8 PEs
//   - LEDs display the currently selected PE count
//////////////////////////////////////////////////////////////////////////////////

module ras_fpga_top (

    input  logic       clk,
    input  logic       rst_n,

    output logic [3:0] LED

);

    // ============================================================
    // Internal reset
    // ============================================================

    logic rst;

    assign rst = ~rst_n;


    // ============================================================
    // RISC-V debug signals
    // ============================================================

    logic [31:0] debug_pc;
    logic [31:0] debug_instruction;

    logic [31:0] debug_x1;
    logic [31:0] debug_x2;
    logic [31:0] debug_x3;

    logic [31:0] debug_mem0;


    // ============================================================
    // RISC-V CORE
    // ============================================================

    ras_riscv_core riscv_core_inst (

        .clk(clk),
        .rst(rst),

        .debug_pc(debug_pc),
        .debug_instruction(debug_instruction),

        .debug_x1(debug_x1),
        .debug_x2(debug_x2),
        .debug_x3(debug_x3),

        .debug_mem0(debug_mem0)

    );


    // ============================================================
    // Accelerator control
    // ============================================================

    logic accelerator_start;
    logic accelerator_clear;


    // ============================================================
    // Start pulse generator
    //
    // Generates a periodic accelerator start pulse.
    // This allows the RL accelerator to operate automatically
    // when implemented on the FPGA.
    // ============================================================

    logic [25:0] start_counter;

    always_ff @(posedge clk) begin

        if (rst) begin

            start_counter <= 26'd0;
            accelerator_start <= 1'b0;
            accelerator_clear <= 1'b0;

        end

        else begin

            accelerator_start <= 1'b0;
            accelerator_clear <= 1'b0;

            if (start_counter == 26'd49_999_999) begin

                start_counter <= 26'd0;

                accelerator_start <= 1'b1;
                accelerator_clear <= 1'b1;

            end

            else begin

                start_counter <= start_counter + 1'b1;

            end

        end

    end


    // ============================================================
    // Accelerator data buses
    //
    // 8 processing elements
    // Each PE receives:
    //
    //     A = 1
    //     B = 2
    //
    // This provides deterministic FPGA test data.
    // ============================================================

    logic [8*16-1:0] data_a_bus;
    logic [8*16-1:0] data_b_bus;

    assign data_a_bus = {
        16'd1, 16'd1, 16'd1, 16'd1,
        16'd1, 16'd1, 16'd1, 16'd1
    };

    assign data_b_bus = {
        16'd2, 16'd2, 16'd2, 16'd2,
        16'd2, 16'd2, 16'd2, 16'd2
    };


    // ============================================================
    // Accelerator signals
    // ============================================================

    logic [8*32-1:0] pe_outputs;

    logic [3:0] active_pe_count;
    logic [1:0] selected_action;

    logic [3:0] current_state;

    logic signed [15:0] reward;

    logic learning_valid;

    logic [31:0] measured_cycles;
    logic [31:0] active_pe_cycles;
    logic [31:0] utilization;

    logic performance_completed;


    // ============================================================
    // RL Adaptive Accelerator
    // ============================================================

    ras_adaptive_accelerator #(
        .MAX_PES(8),
        .COMPUTE_CYCLES(4)
    ) adaptive_accelerator_inst (

        .clk(clk),
        .rst(rst),

        .start(accelerator_start),
        .clear(accelerator_clear),

        // Performance feedback
        .cycle_count_in(measured_cycles),
        .utilization_in(utilization),

        // Accelerator input data
        .data_a_bus(data_a_bus),
        .data_b_bus(data_b_bus),

        // PE results
        .pe_outputs(pe_outputs),

        // RL outputs
        .active_pe_count(active_pe_count),
        .selected_action(selected_action),

        .current_state(current_state),
        .reward(reward),

        .learning_valid(learning_valid),

        // Performance monitor
        .measured_cycles(measured_cycles),
        .active_pe_cycles(active_pe_cycles),
        .utilization(utilization),
        .performance_completed(performance_completed)

    );


    // ============================================================
    // LED OUTPUT
    //
    // Display active PE count:
    //
    // 0010 = 2 PEs
    // 0100 = 4 PEs
    // 1000 = 8 PEs
    // ============================================================

    assign LED = active_pe_count;


endmodule
`timescale 1ns/1ps

module ras_adaptive_accelerator #(
    parameter integer MAX_PES = 8,
    parameter integer COMPUTE_CYCLES = 4
)(
    input  logic clk,
    input  logic rst,

    input  logic start,
    input  logic clear,

    // Kept for compatibility with existing top-level connections
    input  logic [31:0] cycle_count_in,
    input  logic [31:0] utilization_in,

    input  logic [MAX_PES*16-1:0] data_a_bus,
    input  logic [MAX_PES*16-1:0] data_b_bus,

    output logic [MAX_PES*32-1:0] pe_outputs,

    output logic [3:0] active_pe_count,
    output logic [1:0] selected_action,

    output logic [3:0] current_state,
    output logic signed [15:0] reward,

    output logic learning_valid,

    // Performance monitor outputs
    output logic [31:0] measured_cycles,
    output logic [31:0] active_pe_cycles,
    output logic [31:0] utilization,
    output logic performance_completed
);

    // ============================================================
    // RL Signals
    // ============================================================

    logic [1:0] rl_action;
    logic [3:0] rl_pe_count;

    logic [3:0] active_pe_count_reg;


    // ============================================================
    // Accelerator Operation Control
    // ============================================================

    logic operation_active;
    logic operation_done;

    logic rl_done;

    logic [$clog2(COMPUTE_CYCLES + 1)-1:0] compute_counter;


    // ============================================================
    // Performance values captured for RL
    // ============================================================

    logic [31:0] rl_cycle_count;
    logic [31:0] rl_utilization;


    // ============================================================
    // RL learning completion delay
    //
    // The performance monitor updates its outputs when the
    // operation completes. We therefore delay RL learning by
    // one clock so that the RL controller sees the completed
    // performance values.
    // ============================================================

    always_ff @(posedge clk) begin

        if (rst) begin

            rl_done          <= 1'b0;
            rl_cycle_count   <= 32'd0;
            rl_utilization   <= 32'd0;

        end

        else begin

            rl_done <= operation_done;

            if (operation_done) begin

                rl_cycle_count <= measured_cycles;
                rl_utilization <= utilization;

            end

        end

    end


    // ============================================================
    // RL Controller
    // ============================================================

    ras_rl_controller rl_controller_inst (

        .clk(clk),
        .rst(rst),

        .start(start),

        // Delayed completion signal
        .done(rl_done),

        // Actual measured accelerator performance
        .cycle_count(rl_cycle_count),
        .utilization(rl_utilization),

        .action(rl_action),
        .active_pe_count(rl_pe_count),

        .current_state(current_state),
        .reward(reward),

        .learning_valid(learning_valid)

    );


    // ============================================================
    // Register RL-selected PE configuration
    // ============================================================

    always_ff @(posedge clk) begin

        if (rst) begin

            active_pe_count_reg <= 4'd2;

        end

        else if (start && !operation_active) begin

            active_pe_count_reg <= rl_pe_count;

        end

    end


    // ============================================================
    // Accelerator Operation Controller
    // ============================================================

    always_ff @(posedge clk) begin

        if (rst) begin

            operation_active <= 1'b0;
            operation_done   <= 1'b0;
            compute_counter  <= '0;

        end

        else begin

            // Default
            operation_done <= 1'b0;


            // ----------------------------------------------------
            // Start Operation
            // ----------------------------------------------------

            if (start && !operation_active) begin

                operation_active <= 1'b1;
                compute_counter  <= '0;

            end


            // ----------------------------------------------------
            // Operation Running
            // ----------------------------------------------------

            else if (operation_active) begin

                if (compute_counter == (COMPUTE_CYCLES - 1)) begin

                    operation_active <= 1'b0;
                    operation_done   <= 1'b1;
                    compute_counter  <= '0;

                end

                else begin

                    compute_counter <= compute_counter + 1'b1;

                end

            end

        end

    end


    // ============================================================
    // Actual PE Array
    // ============================================================

    ras_pe_array #(
        .MAX_PES(MAX_PES)
    ) pe_array_inst (

        .clk(clk),
        .rst(rst),

        .enable(operation_active),
        .clear(clear),

        .active_pe_count(active_pe_count_reg),

        .data_a_bus(data_a_bus),
        .data_b_bus(data_b_bus),

        .pe_outputs(pe_outputs)

    );


    // ============================================================
    // Performance Monitor
    // ============================================================

    ras_performance_monitor #(
        .MAX_PES(MAX_PES)
    ) performance_monitor_inst (

        .clk(clk),
        .rst(rst),

        .start(start),
        .busy(operation_active),
        .done(operation_done),

        .active_pe_count(active_pe_count_reg),

        .cycle_count(measured_cycles),
        .active_pe_cycles(active_pe_cycles),

        .utilization(utilization),
        .completed(performance_completed)

    );


    // ============================================================
    // Outputs
    // ============================================================

    assign active_pe_count = active_pe_count_reg;

    assign selected_action = rl_action;

endmodule
`timescale 1ns/1ps

module ras_rl_adaptation_tb;

localparam integer MAX_PES = 8;

logic clk;
logic rst;
logic start;
logic clear;

logic [31:0] cycle_count;
logic [31:0] utilization;

logic [MAX_PES*16-1:0] data_a_bus;
logic [MAX_PES*16-1:0] data_b_bus;

logic [MAX_PES*32-1:0] pe_outputs;

logic [3:0] active_pe_count;
logic [1:0] selected_action;

logic [3:0] current_state;
logic signed [15:0] reward;

logic learning_valid;

logic [31:0] measured_cycles;
logic [31:0] active_pe_cycles;
logic [31:0] measured_utilization;
logic performance_completed;


// =====================================================
// DUT
// =====================================================

ras_adaptive_accelerator #(
    .MAX_PES(MAX_PES),
    .COMPUTE_CYCLES(4)
) dut (

    .clk(clk),
    .rst(rst),

    .start(start),
    .clear(clear),

    .cycle_count_in(cycle_count),
    .utilization_in(utilization),

    .data_a_bus(data_a_bus),
    .data_b_bus(data_b_bus),

    .pe_outputs(pe_outputs),

    .active_pe_count(active_pe_count),
    .selected_action(selected_action),

    .current_state(current_state),
    .reward(reward),

    .learning_valid(learning_valid),

    .measured_cycles(measured_cycles),
    .active_pe_cycles(active_pe_cycles),
    .utilization(measured_utilization),
    .performance_completed(performance_completed)
);


// =====================================================
// Clock
// =====================================================

always #5 clk = ~clk;


// =====================================================
// Task: Run one accelerator operation
// =====================================================

task automatic run_operation(
    input logic [31:0] test_cycles,
    input logic [31:0] test_utilization
);

begin

    cycle_count = test_cycles;
    utilization = test_utilization;

    start = 1'b1;

    @(posedge clk);
    #1;

    start = 1'b0;

    wait(performance_completed);

    #2;

    $display("-----------------------------------------");
    $display("RL ADAPTATION TEST");
    $display("Input cycle count = %0d", test_cycles);
    $display("Input utilization = %0d / 1000",
             test_utilization);
    $display("Current state     = %0d",
             current_state);
    $display("Selected action   = %0d",
             selected_action);
    $display("Active PE count   = %0d",
             active_pe_count);
    $display("Reward            = %0d",
             reward);
    $display("Learning valid    = %0d",
             learning_valid);
    $display("Measured cycles   = %0d",
             measured_cycles);
    $display("Measured util.    = %0d / 1000",
             measured_utilization);
    $display("-----------------------------------------");

end

endtask


// =====================================================
// Test
// =====================================================

initial begin

    clk = 1'b0;

    rst = 1'b1;
    start = 1'b0;
    clear = 1'b0;

    cycle_count = 32'd0;
    utilization = 32'd0;

    data_a_bus = '0;
    data_b_bus = '0;


    // =================================================
    // Reset
    // =================================================

    #12;

    rst = 1'b0;


    // =================================================
    // Test data
    // =================================================

    data_a_bus[0*16 +: 16] = 16'd2;
    data_b_bus[0*16 +: 16] = 16'd3;

    data_a_bus[1*16 +: 16] = 16'd3;
    data_b_bus[1*16 +: 16] = 16'd4;

    data_a_bus[2*16 +: 16] = 16'd4;
    data_b_bus[2*16 +: 16] = 16'd5;

    data_a_bus[3*16 +: 16] = 16'd5;
    data_b_bus[3*16 +: 16] = 16'd6;

    data_a_bus[4*16 +: 16] = 16'd6;
    data_b_bus[4*16 +: 16] = 16'd7;

    data_a_bus[5*16 +: 16] = 16'd7;
    data_b_bus[5*16 +: 16] = 16'd8;

    data_a_bus[6*16 +: 16] = 16'd8;
    data_b_bus[6*16 +: 16] = 16'd9;

    data_a_bus[7*16 +: 16] = 16'd9;
    data_b_bus[7*16 +: 16] = 16'd10;


    // =================================================
    // Clear accelerator
    // =================================================

    clear = 1'b1;

    @(posedge clk);
    #1;

    clear = 1'b0;


    // =================================================
    // OPERATION 1
    //
    // High utilization condition
    // =================================================

    run_operation(
        32'd4,
        32'd900
    );


    // =================================================
    // OPERATION 2
    //
    // Medium utilization condition
    // =================================================

    run_operation(
        32'd8,
        32'd500
    );


    // =================================================
    // OPERATION 3
    //
    // Low utilization condition
    // =================================================

    run_operation(
        32'd16,
        32'd200
    );


    // =================================================
    // Final verification
    // =================================================

    $display("");
    $display("=========================================");
    $display("      STEP 24 RL ADAPTATION TEST");
    $display("=========================================");

    $display("Final state       = %0d", current_state);
    $display("Final action      = %0d", selected_action);
    $display("Final PE count    = %0d", active_pe_count);
    $display("Final reward      = %0d", reward);
    $display("Learning valid    = %0d", learning_valid);

    $display("=========================================");


    // Action must be a valid 2-bit action
    assert(selected_action <= 2'd3)
        else $error("Invalid RL action");


    // PE count must remain within available PE range
    assert((active_pe_count >= 4'd1) &&
           (active_pe_count <= MAX_PES))
        else $error(
            "Invalid active PE count: %0d",
            active_pe_count
        );


    // Performance measurement must complete
    assert(performance_completed == 1'b1)
        else $error(
            "Performance measurement did not complete"
        );


    $display("");
    $display("=========================================");
    $display(" STEP 24 RL ADAPTATION TEST PASSED");
    $display("=========================================");

    $finish;

end

endmodule
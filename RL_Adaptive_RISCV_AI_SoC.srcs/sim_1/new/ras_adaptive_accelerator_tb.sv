`timescale 1ns/1ps

module ras_adaptive_accelerator_tb;

localparam integer MAX_PES = 8;

logic clk;
logic rst;

logic start;
logic clear;

// Performance inputs to RL controller
logic [31:0] cycle_count;
logic [31:0] utilization;

// Data buses
logic [MAX_PES*16-1:0] data_a_bus;
logic [MAX_PES*16-1:0] data_b_bus;

// PE outputs
logic [MAX_PES*32-1:0] pe_outputs;

// RL outputs
logic [3:0] active_pe_count;
logic [1:0] selected_action;

logic [3:0] current_state;
logic signed [15:0] reward;

logic learning_valid;

// Performance monitor outputs
logic [31:0] measured_cycles;
logic [31:0] active_pe_cycles;
logic [31:0] measured_utilization;
logic performance_completed;


// =================================================
// DUT
// =================================================

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


// =================================================
// Clock
// =================================================

always #5 clk = ~clk;


// =================================================
// Start one accelerator operation
// =================================================

task automatic run_operation;

begin

    start = 1'b1;

    @(posedge clk);
    #1;

    start = 1'b0;

    // Wait for performance monitor
    wait(performance_completed);

    #2;

    $display("");
    $display("-----------------------------------------");
    $display("OPERATION COMPLETE");
    $display("Selected action     = %0d",
             selected_action);

    $display("Active PE count     = %0d",
             active_pe_count);

    $display("Current state       = %0d",
             current_state);

    $display("Reward              = %0d",
             reward);

    $display("Learning valid      = %0d",
             learning_valid);

    $display("Measured cycles     = %0d",
             measured_cycles);

    $display("Active PE cycles    = %0d",
             active_pe_cycles);

    $display("Utilization         = %0d / 1000",
             measured_utilization);

    $display("-----------------------------------------");

end

endtask


// =================================================
// Main Test
// =================================================

initial begin

    clk = 1'b0;

    rst = 1'b1;
    start = 1'b0;
    clear = 1'b0;

    // Initial performance information
    cycle_count = 32'd5;
    utilization = 32'd900;

    data_a_bus = '0;
    data_b_bus = '0;


    // =================================================
    // RESET
    // =================================================

    #12;

    rst = 1'b0;


    // =================================================
    // TEST DATA
    //
    // PE0 = 2 × 3 = 6
    // PE1 = 3 × 4 = 12
    // PE2 = 4 × 5 = 20
    // PE3 = 5 × 6 = 30
    // =================================================

    data_a_bus[0*16 +: 16] = 16'sd2;
    data_b_bus[0*16 +: 16] = 16'sd3;

    data_a_bus[1*16 +: 16] = 16'sd3;
    data_b_bus[1*16 +: 16] = 16'sd4;

    data_a_bus[2*16 +: 16] = 16'sd4;
    data_b_bus[2*16 +: 16] = 16'sd5;

    data_a_bus[3*16 +: 16] = 16'sd5;
    data_b_bus[3*16 +: 16] = 16'sd6;


    // =================================================
    // CLEAR
    // =================================================

    clear = 1'b1;

    @(posedge clk);
    #1;

    clear = 1'b0;


    // =================================================
    // OPERATION 1
    // =================================================

    $display("");
    $display("=========================================");
    $display("       OPERATION 1");
    $display("=========================================");

    run_operation;


    // =================================================
    // Update performance information
    // for next RL decision
    // =================================================

    cycle_count = measured_cycles;
    utilization = measured_utilization;


    // =================================================
    // OPERATION 2
    // =================================================

    $display("");
    $display("=========================================");
    $display("       OPERATION 2");
    $display("=========================================");

    run_operation;


    // =================================================
    // Update performance information again
    // =================================================

    cycle_count = measured_cycles;
    utilization = measured_utilization;


    // =================================================
    // OPERATION 3
    // =================================================

    $display("");
    $display("=========================================");
    $display("       OPERATION 3");
    $display("=========================================");

    run_operation;


    // =================================================
    // FINAL RESULTS
    // =================================================

    $display("");
    $display("=========================================");
    $display(" MULTI-OPERATION ADAPTIVE TEST COMPLETE");
    $display("=========================================");

    $display("Final selected action = %0d",
             selected_action);

    $display("Final active PEs      = %0d",
             active_pe_count);

    $display("Final state           = %0d",
             current_state);

    $display("Final reward          = %0d",
             reward);

    $display("Final utilization     = %0d / 1000",
             measured_utilization);

    $display("Learning valid        = %0d",
             learning_valid);

    $display("=========================================");


    // =================================================
    // Basic Verification
    // =================================================

    assert(measured_cycles == 32'd4)
        else $error(
            "Expected 4 measured cycles"
        );

    assert(active_pe_count >= 4'd1 &&
           active_pe_count <= MAX_PES)
        else $error(
            "Invalid active PE count: %0d",
            active_pe_count
        );

    assert(pe_outputs[0*32 +: 32] == 32'sd6)
        else $error(
            "PE0 computation incorrect"
        );

    assert(pe_outputs[1*32 +: 32] == 32'sd12)
        else $error(
            "PE1 computation incorrect"
        );


    $display("");
    $display("=========================================");
    $display(" STEP 22 MULTI-OPERATION TEST PASSED");
    $display("=========================================");

    $finish;

end

endmodule
`timescale 1ns/1ps

module ras_pe_array_scaling_tb;

localparam integer MAX_PES = 8;

logic clk;
logic rst;
logic enable;
logic clear;

logic [3:0] active_pe_count;

logic [MAX_PES*16-1:0] data_a_bus;
logic [MAX_PES*16-1:0] data_b_bus;

logic [MAX_PES*32-1:0] pe_outputs;


// =====================================================
// DUT
// =====================================================

ras_pe_array #(
    .MAX_PES(MAX_PES)
) dut (

    .clk(clk),
    .rst(rst),

    .enable(enable),
    .clear(clear),

    .active_pe_count(active_pe_count),

    .data_a_bus(data_a_bus),
    .data_b_bus(data_b_bus),

    .pe_outputs(pe_outputs)
);


// =====================================================
// Clock
// =====================================================

always #5 clk = ~clk;


// =====================================================
// Test
// =====================================================

initial begin

    clk = 1'b0;
    rst = 1'b1;
    enable = 1'b0;
    clear = 1'b0;

    data_a_bus = '0;
    data_b_bus = '0;
    active_pe_count = 4'd0;


    // =================================================
    // Reset
    // =================================================

    #12;

    rst = 1'b0;


    // =================================================
    // Give every PE a unique computation
    //
    // PE0 = 1 × 2 = 2
    // PE1 = 2 × 3 = 6
    // PE2 = 3 × 4 = 12
    // PE3 = 4 × 5 = 20
    // PE4 = 5 × 6 = 30
    // PE5 = 6 × 7 = 42
    // PE6 = 7 × 8 = 56
    // PE7 = 8 × 9 = 72
    // =================================================

    data_a_bus[0*16 +: 16] = 16'd1;
    data_b_bus[0*16 +: 16] = 16'd2;

    data_a_bus[1*16 +: 16] = 16'd2;
    data_b_bus[1*16 +: 16] = 16'd3;

    data_a_bus[2*16 +: 16] = 16'd3;
    data_b_bus[2*16 +: 16] = 16'd4;

    data_a_bus[3*16 +: 16] = 16'd4;
    data_b_bus[3*16 +: 16] = 16'd5;

    data_a_bus[4*16 +: 16] = 16'd5;
    data_b_bus[4*16 +: 16] = 16'd6;

    data_a_bus[5*16 +: 16] = 16'd6;
    data_b_bus[5*16 +: 16] = 16'd7;

    data_a_bus[6*16 +: 16] = 16'd7;
    data_b_bus[6*16 +: 16] = 16'd8;

    data_a_bus[7*16 +: 16] = 16'd8;
    data_b_bus[7*16 +: 16] = 16'd9;


    // =================================================
    // Clear
    // =================================================

    clear = 1'b1;

    @(posedge clk);
    #1;

    clear = 1'b0;


    // =================================================
    // Enable PE array
    // =================================================

    enable = 1'b1;


    // =================================================
    // TEST 1: 2 PEs
    // =================================================

    active_pe_count = 4'd2;

    @(posedge clk);
    #1;

    $display("-----------------------------------------");
    $display("TEST 1: 2 ACTIVE PEs");
    $display("PE0 = %0d",
        $signed(pe_outputs[0*32 +: 32]));
    $display("PE1 = %0d",
        $signed(pe_outputs[1*32 +: 32]));
    $display("PE2 = %0d",
        $signed(pe_outputs[2*32 +: 32]));


    assert(pe_outputs[0*32 +: 32] == 32'd2)
        else $error("PE0 incorrect");

    assert(pe_outputs[1*32 +: 32] == 32'd6)
        else $error("PE1 incorrect");

    assert(pe_outputs[2*32 +: 32] == 32'd0)
        else $error("PE2 should be inactive");


    // =================================================
    // TEST 2: 4 PEs
    // =================================================

    active_pe_count = 4'd4;

    @(posedge clk);
    #1;

    $display("-----------------------------------------");
    $display("TEST 2: 4 ACTIVE PEs");

    assert(pe_outputs[0*32 +: 32] == 32'd2)
        else $error("PE0 incorrect");

    assert(pe_outputs[1*32 +: 32] == 32'd6)
        else $error("PE1 incorrect");

    assert(pe_outputs[2*32 +: 32] == 32'd12)
        else $error("PE2 incorrect");

    assert(pe_outputs[3*32 +: 32] == 32'd20)
        else $error("PE3 incorrect");

    assert(pe_outputs[4*32 +: 32] == 32'd0)
        else $error("PE4 should be inactive");


    // =================================================
    // TEST 3: 6 PEs
    // =================================================

    active_pe_count = 4'd6;

    @(posedge clk);
    #1;

    $display("-----------------------------------------");
    $display("TEST 3: 6 ACTIVE PEs");

    assert(pe_outputs[4*32 +: 32] == 32'd30)
        else $error("PE4 incorrect");

    assert(pe_outputs[5*32 +: 32] == 32'd42)
        else $error("PE5 incorrect");

    assert(pe_outputs[6*32 +: 32] == 32'd0)
        else $error("PE6 should be inactive");


    // =================================================
    // TEST 4: 8 PEs
    // =================================================

    active_pe_count = 4'd8;

    @(posedge clk);
    #1;

    $display("-----------------------------------------");
    $display("TEST 4: 8 ACTIVE PEs");

    assert(pe_outputs[6*32 +: 32] == 32'd56)
        else $error("PE6 incorrect");

    assert(pe_outputs[7*32 +: 32] == 32'd72)
        else $error("PE7 incorrect");


    // =================================================
    // Final result
    // =================================================

    $display("-----------------------------------------");
    $display("PE ARRAY SCALING TEST PASSED");
    $display("-----------------------------------------");

    $finish;

end

endmodule
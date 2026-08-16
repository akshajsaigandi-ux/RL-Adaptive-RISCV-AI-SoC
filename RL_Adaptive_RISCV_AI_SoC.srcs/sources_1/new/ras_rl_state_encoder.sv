module ras_rl_state_encoder (

    input  logic [31:0] utilization,
    input  logic [31:0] cycle_count,
    input  logic [3:0]  active_pe_count,

    output logic [3:0]  state
);

    logic [1:0] utilization_class;
    logic [1:0] performance_class;

    always_comb begin

        // --------------------------------------------
        // Utilization classification
        //
        // 0 = LOW
        // 1 = MEDIUM
        // 2 = HIGH
        // --------------------------------------------

        if (utilization < 32'd250)
            utilization_class = 2'd0;

        else if (utilization < 32'd750)
            utilization_class = 2'd1;

        else
            utilization_class = 2'd2;


        // --------------------------------------------
        // Performance classification
        //
        // 0 = FAST
        // 1 = MEDIUM
        // 2 = SLOW
        // --------------------------------------------

        if (cycle_count < 32'd10)
            performance_class = 2'd0;

        else if (cycle_count < 32'd20)
            performance_class = 2'd1;

        else
            performance_class = 2'd2;


        // --------------------------------------------
        // Encode state
        // --------------------------------------------

        state =
            (utilization_class * 4'd3)
            + performance_class;

    end

endmodule
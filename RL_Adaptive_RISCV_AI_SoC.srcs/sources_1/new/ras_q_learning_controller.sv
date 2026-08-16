module ras_q_learning_controller #(
    parameter integer NUM_STATES  = 9,
    parameter integer NUM_ACTIONS = 3
)(
    input  logic       clk,
    input  logic       rst,

    input  logic [3:0] state,

    output logic [1:0] action,
    output logic [3:0] active_pe_count
);

    // --------------------------------------------------
    // Q-table
    //
    // Action 0 -> 2 PEs
    // Action 1 -> 4 PEs
    // Action 2 -> 8 PEs
    //
    // Signed fixed-point/integer Q-values.
    // --------------------------------------------------

    logic signed [15:0] q_table [0:NUM_STATES-1][0:NUM_ACTIONS-1];

    integer i;
    integer j;

    logic signed [15:0] q0;
    logic signed [15:0] q1;
    logic signed [15:0] q2;

    // --------------------------------------------------
    // Initial Q-table
    //
    // This is only a starting policy.
    // The learning/update block will modify these
    // values in the next stage.
    // --------------------------------------------------

    always_ff @(posedge clk) begin

        if (rst) begin

            for (i = 0; i < NUM_STATES; i = i + 1) begin
                for (j = 0; j < NUM_ACTIONS; j = j + 1) begin
                    q_table[i][j] <= 16'sd0;
                end
            end

            // State 0 -> prefer 2 PEs
            q_table[0][0] <= 16'sd10;
            q_table[0][1] <= 16'sd5;
            q_table[0][2] <= 16'sd2;

            // State 4 -> prefer 4 PEs
            q_table[4][0] <= 16'sd3;
            q_table[4][1] <= 16'sd12;
            q_table[4][2] <= 16'sd8;

            // State 8 -> prefer 8 PEs
            q_table[8][0] <= 16'sd1;
            q_table[8][1] <= 16'sd4;
            q_table[8][2] <= 16'sd15;

        end

    end


    // --------------------------------------------------
    // Select action with maximum Q-value
    // --------------------------------------------------

    always_comb begin

        q0 = q_table[state][0];
        q1 = q_table[state][1];
        q2 = q_table[state][2];

        // Default
        action = 2'd0;

        if ((q1 > q0) && (q1 >= q2))
            action = 2'd1;

        else if ((q2 > q0) && (q2 > q1))
            action = 2'd2;

        else
            action = 2'd0;


        // ------------------------------------------------
        // Convert action into PE configuration
        // ------------------------------------------------

        case (action)

            2'd0:
                active_pe_count = 4'd2;

            2'd1:
                active_pe_count = 4'd4;

            2'd2:
                active_pe_count = 4'd8;

            default:
                active_pe_count = 4'd2;

        endcase

    end

endmodule
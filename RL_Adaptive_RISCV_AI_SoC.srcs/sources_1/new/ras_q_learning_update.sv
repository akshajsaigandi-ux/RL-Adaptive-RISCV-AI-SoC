module ras_q_learning_update (
    input  logic        clk,
    input  logic        rst,
    input  logic        update_en,

    input  logic [31:0] cycle_count,
    input  logic [31:0] utilization,

    input  logic signed [15:0] q_old,

    output logic signed [15:0] reward,
    output logic signed [15:0] q_new
);

    logic signed [15:0] performance_reward;
    logic signed [15:0] utilization_reward;

    logic signed [15:0] reward_combined;
    logic signed [15:0] q_error;
    logic signed [15:0] q_update;

    // --------------------------------------------------
    // Reward calculation
    // --------------------------------------------------

    always_comb begin

        // Performance reward
        if (cycle_count < 32'd10)
            performance_reward = 16'sd10;

        else if (cycle_count < 32'd20)
            performance_reward = 16'sd5;

        else
            performance_reward = -16'sd5;


        // Utilization reward
        if (utilization >= 32'd750)
            utilization_reward = 16'sd5;

        else if (utilization >= 32'd500)
            utilization_reward = 16'sd2;

        else
            utilization_reward = -16'sd2;


        // Total reward
        reward_combined =
            performance_reward + utilization_reward;

        reward = reward_combined;


        // ------------------------------------------------
        // Q-learning update
        //
        // alpha = 1/4
        //
        // Qnew = Qold + alpha*(reward-Qold)
        //
        // Implemented as:
        //
        // Qnew = Qold + ((reward-Qold) >>> 2)
        // ------------------------------------------------

        q_error = reward_combined - q_old;

        q_update = q_error >>> 2;

        q_new = q_old + q_update;

    end

endmodule
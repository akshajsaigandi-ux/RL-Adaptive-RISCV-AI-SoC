module ras_rl_controller #(
    parameter integer NUM_STATES  = 9,
    parameter integer NUM_ACTIONS = 3
)(
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic done,
    input  logic [31:0] cycle_count,
    input  logic [31:0] utilization,

    output logic [1:0] action,
    output logic [3:0] active_pe_count,
    output logic [3:0] current_state,
    output logic signed [15:0] reward,
    output logic learning_valid
);

    logic [3:0] rl_state;
    logic signed [15:0] q_table [0:NUM_STATES-1][0:NUM_ACTIONS-1];

    logic [3:0] stored_state;
    logic [1:0] stored_action;
    logic episode_active;

    logic signed [15:0] q0,q1,q2,max_next_q;
    logic signed [15:0] performance_reward;
    logic signed [15:0] utilization_reward;
    logic signed [15:0] reward_combined;

    logic signed [15:0] q_old_reg;
    logic signed [15:0] max_next_q_reg;
    logic signed [15:0] reward_reg;

    logic update_pending;

    logic signed [31:0] target_ext;
    logic signed [31:0] q_error_ext;
    logic signed [31:0] q_new_ext;

    ras_rl_state_encoder state_encoder(
        .utilization(utilization),
        .cycle_count(cycle_count),
        .active_pe_count(active_pe_count),
        .state(rl_state)
    );

    assign current_state = rl_state;

    always_comb begin

        if (cycle_count < 10)
            performance_reward = 16'sd1000;
        else if (cycle_count < 20)
            performance_reward = 16'sd500;
        else
            performance_reward = -16'sd500;

        if (utilization >= 750)
            utilization_reward = 16'sd500;
        else if (utilization >= 500)
            utilization_reward = 16'sd200;
        else
            utilization_reward = -16'sd200;

        reward_combined = performance_reward + utilization_reward;
        reward = reward_combined / 100;

    end

    always_comb begin

        q0 = q_table[rl_state][0];
        q1 = q_table[rl_state][1];
        q2 = q_table[rl_state][2];

        if ((q0 >= q1) && (q0 >= q2))
            max_next_q = q0;
        else if (q1 >= q2)
            max_next_q = q1;
        else
            max_next_q = q2;

    end

    always_comb begin

        if ((q1 > q0) && (q1 >= q2))
            action = 2'd1;
        else if ((q2 > q0) && (q2 > q1))
            action = 2'd2;
        else
            action = 2'd0;

        case(action)
            2'd0: active_pe_count = 2;
            2'd1: active_pe_count = 4;
            2'd2: active_pe_count = 8;
            default: active_pe_count = 2;
        endcase

    end

    always_comb begin

        target_ext = reward_reg + ((max_next_q_reg * 3) >>> 2);
        q_error_ext = target_ext - q_old_reg;
        q_new_ext = q_old_reg + (q_error_ext >>> 2);

    end

    always_ff @(posedge clk) begin

        if (rst) begin

            episode_active <= 0;
            update_pending <= 0;
            learning_valid <= 0;
            stored_state <= 0;
            stored_action <= 0;

            q_table[0][0]<=5000; q_table[0][1]<=5690; q_table[0][2]<=5819;
            q_table[1][0]<=5230; q_table[1][1]<=5299; q_table[1][2]<=5768;
            q_table[2][0]<=5384; q_table[2][1]<=5792; q_table[2][2]<=5703;
            q_table[3][0]<=5446; q_table[3][1]<=5725; q_table[3][2]<=5594;
            q_table[4][0]<=5202; q_table[4][1]<=5640; q_table[4][2]<=5740;
            q_table[5][0]<=5343; q_table[5][1]<=5646; q_table[5][2]<=5653;
            q_table[6][0]<=5249; q_table[6][1]<=5793; q_table[6][2]<=5459;
            q_table[7][0]<=5691; q_table[7][1]<=5679; q_table[7][2]<=5652;
            q_table[8][0]<=5393; q_table[8][1]<=5501; q_table[8][2]<=5678;

        end
        else begin

            learning_valid <= 0;

            if (start && !episode_active) begin

                stored_state <= rl_state;
                stored_action <= action;
                episode_active <= 1;

            end

            if (done && episode_active) begin

                q_old_reg <= q_table[stored_state][stored_action];
                max_next_q_reg <= max_next_q;
                reward_reg <= reward_combined;

                update_pending <= 1;
                episode_active <= 0;

            end

            if (update_pending) begin

                q_table[stored_state][stored_action] <= q_new_ext[15:0];
                update_pending <= 0;
                learning_valid <= 1;

            end

        end

    end

endmodule
module ras_rl_policy (
    input  logic [3:0] state,

    output logic [1:0] action,
    output logic [3:0] active_pe_count
);

always_comb begin

    case (state)

        4'd0: action = 2'd2;   // 8 PEs
        4'd1: action = 2'd2;   // 8 PEs
        4'd2: action = 2'd1;   // 4 PEs
        4'd3: action = 2'd1;   // 4 PEs
        4'd4: action = 2'd2;   // 8 PEs
        4'd5: action = 2'd2;   // 8 PEs
        4'd6: action = 2'd1;   // 4 PEs
        4'd7: action = 2'd0;   // 2 PEs
        4'd8: action = 2'd2;   // 8 PEs

        default: action = 2'd0;

    endcase


    case (action)

        2'd0: active_pe_count = 4'd2;
        2'd1: active_pe_count = 4'd4;
        2'd2: active_pe_count = 4'd8;

        default: active_pe_count = 4'd2;

    endcase

end

endmodule
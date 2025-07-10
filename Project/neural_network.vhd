module neural_network (
		input   wire        clk,
		input   wire        rst,
		input   wire        start,
		input   wire [23:0] input_data,
		output  reg  [15:0] output_data,
		output  reg         valid_out,
		output  wire        ready
);


		localparam [3:0]
		S_RESET   = 4'd0,
		S_IDLE    = 4'd1,
		S_FETCH_X = 4'd2,
		S_MAC_H   = 4'd3,
		S_ACT_H   = 4'd4,
		S_MAC_Y   = 4'd5,
		S_ACT_Y   = 4'd6,
		S_WRITE_Y = 4'd7;

		reg [3:0] current_state, next_state;
		reg [1:0] h_cycle_count;
		reg [2:0] y_cycle_count;


		reg signed [7:0] W1 [0:3][0:2];
		reg signed [7:0] b1 [0:3];
		reg signed [7:0] W2 [0:1][0:3];
		reg signed [7:0] b2 [0:1];


		reg [23:0] input_reg;
		wire [7:0]  hidden_act [0:3];
		wire [15:0] mac_h_res [0:3];
		wire [15:0] mac_y_res [0:1];
		wire [7:0]  output_act [0:1];


		wire mac_h_enable = (current_state == S_MAC_H);
		wire mac_h_clear  = (current_state == S_FETCH_X);
		wire mac_y_enable = (current_state == S_MAC_Y);
		wire mac_y_clear  = (current_state == S_ACT_H);
		assign ready = (current_state == S_IDLE);

		initial begin

		W1[0][0] = 8'd2; W1[0][1] = 8'd3; W1[0][2] = 8'd1;
		W1[1][0] = 8'd3; W1[1][1] = 8'd1; W1[1][2] = 8'd2;
		W1[2][0] = 8'd1; W1[2][1] = 8'd2; W1[2][2] = 8'd3;
		W1[3][0] = 8'd2; W1[3][1] = 8'd1; W1[3][2] = 8'd3;


		b1[0] = 8'd1; b1[1] = 8'd1; b1[2] = 8'd1; b1[3] = 8'd1;


		W2[0][0] = 8'd1; W2[0][1] = 8'd2; W2[0][2] = 8'd1; W2[0][3] = 8'd2;
		W2[1][0] = 8'd2; W2[1][1] = 8'd1; W2[1][2] = 8'd2; W2[1][3] = 8'd1;


		b2[0] = 8'd1; b2[1] = 8'd1;
		end


		reg [7:0] current_input_byte;
		always @(*) begin
		case (h_cycle_count)
		2'd0: current_input_byte = input_reg[23:16];
		2'd1: current_input_byte = input_reg[15:8];
		2'd2: current_input_byte = input_reg[7:0];
		default: current_input_byte = 8'd0;
		endcase
		end


		reg [7:0] current_hidden_act;
		always @(*) begin
		case (y_cycle_count)
		3'd0: current_hidden_act = hidden_act[0];
		3'd1: current_hidden_act = hidden_act[1];
		3'd2: current_hidden_act = hidden_act[2];
		3'd3: current_hidden_act = hidden_act[3];
		default: current_hidden_act = 8'd0;
		endcase
		end


		genvar i;
		generate
		for (i = 0; i < 4; i = i + 1) begin: hidden_macs
		mac mac_h (
		.clock(clk),
		.reset(rst),
		.enable(mac_h_enable),
		.clear_accumulator(mac_h_clear),
		.data_in(current_input_byte),
		.weight(W1[i][h_cycle_count]),
		.bias(b1[i]),
		.result(mac_h_res[i]),
		.valid()
		);
		end
		endgenerate


		generate
		for (i = 0; i < 4; i = i + 1) begin: hidden_act_units
		relu relu_h (
		.data_in(mac_h_res[i]),
		.data_out(hidden_act[i])
		);
		end
		endgenerate


		genvar k;
		generate
		for (k = 0; k < 2; k = k + 1) begin: output_macs
		mac mac_y (
		.clock(clk),
		.reset(rst),
		.enable(mac_y_enable),
		.clear_accumulator(mac_y_clear),
		.data_in(current_hidden_act),
		.weight(W2[k][y_cycle_count]),
		.bias(b2[k]),
		.result(mac_y_res[k]),
		.valid()
		);
		end
		endgenerate


		relu relu_y0 (
		.data_in(mac_y_res[0]),
		.data_out(output_act[0])
		);

		relu relu_y1 (
		.data_in(mac_y_res[1]),
		.data_out(output_act[1])
		);


		always @(posedge clk or posedge rst) begin
		if (rst) begin
		current_state <= S_RESET;
		h_cycle_count <= 0;
		y_cycle_count <= 0;
		valid_out     <= 1'b0;
		input_reg     <= 24'd0;
		end else begin
		current_state <= next_state;
		valid_out     <= 1'b0;

		case(current_state)
		S_FETCH_X: begin
		input_reg <= input_data;
		end
		S_MAC_H: begin
		if (h_cycle_count < 2) begin
			h_cycle_count <= h_cycle_count + 1;
		end
		end
		S_ACT_H: begin
		h_cycle_count <= 0;
		end
		S_MAC_Y: begin
		if (y_cycle_count < 3) begin
			y_cycle_count <= y_cycle_count + 1;
		end
		end
		S_ACT_Y: begin
		y_cycle_count <= 0;
		end
		S_WRITE_Y: begin
		output_data <= {output_act[0], output_act[1]};
		valid_out   <= 1'b1;
		end
		endcase
		end
		end


		always @(*) begin
		next_state = current_state;
		case(current_state)
		S_RESET:   next_state = S_IDLE;
		S_IDLE:    if (start) next_state = S_FETCH_X;
		S_FETCH_X: next_state = S_MAC_H;
		S_MAC_H:   if (h_cycle_count == 2) next_state = S_ACT_H;
		S_ACT_H:   next_state = S_MAC_Y;
		S_MAC_Y:   if (y_cycle_count == 3) next_state = S_ACT_Y;
		S_ACT_Y:   next_state = S_WRITE_Y;
		S_WRITE_Y: next_state = S_IDLE;
		default:   next_state = S_RESET;
		endcase
		end

		endmodule

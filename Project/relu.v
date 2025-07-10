module relu(
		input [15:0] data_in,
		output reg [7:0] data_out
);
		wire signed [15:0] signed_in = data_in; 

		always @(*) begin
		if(signed_in <= 0) begin
			data_out = 8'd0;
		end
		else if(signed_in > 255) begin
			data_out = 8'd255;
		end
		else begin
			data_out = data_in[7:0]; 
		end
		end
		endmodule

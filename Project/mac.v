module mac(
    input clock,
    input reset,
    input enable,
    input clear_accumulator,
    input [7:0] data_in,
    input [7:0] weight,
    input [7:0] bias,
    output [15:0] result,
    output valid
);

    reg signed [15:0] accumulator;
    wire signed [15:0] mult_result;
    wire signed [15:0] signed_bias;
    
    assign mult_result = $signed(data_in) * $signed(weight);
    assign signed_bias = { {8{bias[7]}}, bias };
    assign result = $signed(accumulator) + signed_bias;
    
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            accumulator <= 16'b0;
            valid <= 1'b0;
        end
        else begin
            if (clear_accumulator) begin
                accumulator <= 16'b0;
                valid <= 1'b0;
            end
            else if (enable) begin
                accumulator <= accumulator + mult_result;
                valid <= 1'b1;
            end
            else begin
                valid <= 1'b0;
            end
        end
    end

endmodule

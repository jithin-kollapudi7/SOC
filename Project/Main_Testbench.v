module Main_Testbench;

		reg clk;
		reg rst;
		reg start;
		reg [23:0] input_data;
		wire [15:0] output_data;
		wire valid_out;
		wire ready;

		integer test_case_num = 0;
		integer pass_count = 0;
		integer fail_count = 0;

		neural_network dut (
		.clk(clk),
		.rst(rst),
		.start(start),
		.input_data(input_data),
		.output_data(output_data),
		.valid_out(valid_out),
		.ready(ready)
		);


		always #5 clk = ~clk;


		initial begin
		$dumpfile("neural_network.vcd");
		$dumpvars(0,Main_Testbench);
		end


		task reset_dut;
		begin
			rst = 1;
			#20;
			rst = 0;
			#5;
		end
		endtask


		task run_test;
		input [23:0] in_vector;
		input [15:0] expected_out;
		reg [7:0] exp_out0, exp_out1;
		reg [7:0] act_out0, act_out1;
		integer timeout;

		begin
			test_case_num = test_case_num + 1;
			exp_out0 = expected_out[15:8];
			exp_out1 = expected_out[7:0];
			

			wait(ready);
			@(posedge clk);
			

			input_data = in_vector;
			start = 1;
			@(posedge clk);
			start = 0;
			

			timeout = 0;
			while (!valid_out && timeout < 20) begin
				 @(posedge clk);
				 timeout = timeout + 1;
			end
			
			if (!valid_out) begin
				 $display("[%0t] ERROR: Timeout waiting for valid_out", $time);
				 fail_count = fail_count + 1;
			end
			else begin
				 act_out0 = output_data[15:8];
				 act_out1 = output_data[7:0];
				 
				 if ((act_out0 === exp_out0) && (act_out1 === exp_out1)) begin
					  $display("[%0t] TEST %0d PASSED: Input={%0d,%0d,%0d} Output={%0d,%0d} Expected={%0d,%0d}",
								  $time, test_case_num,
								  $signed(in_vector[23:16]), $signed(in_vector[15:8]), $signed(in_vector[7:0]),
								  act_out0, act_out1, exp_out0, exp_out1);
					  pass_count = pass_count + 1;
				 end
				 else begin
					  $display("[%0t] TEST %0d FAILED: Input={%0d,%0d,%0d} Output={%0d,%0d} Expected={%0d,%0d}",
								  $time, test_case_num,
								  $signed(in_vector[23:16]), $signed(in_vector[15:8]), $signed(in_vector[7:0]),
								  act_out0, act_out1, exp_out0, exp_out1);
					  fail_count = fail_count + 1;
				 end
			end
			

			wait(ready);
			#20; 
		end
		endtask


		initial begin

		clk = 0;
		rst = 1;
		start = 0;
		input_data = 0;
		#10;

		reset_dut();


		run_test(24'h010203, {8'd80, 8'd81}); 
		run_test(24'h030201, {8'd78, 8'd77}); 
		run_test(24'h000000, {8'd7, 8'd7});   
		run_test(24'hFFFEFD, {8'd1, 8'd1});   


		$display("\nTEST SUMMARY: %0d PASSED, %0d FAILED", pass_count, fail_count);


		#100;
		$finish;
		end

		endmodule

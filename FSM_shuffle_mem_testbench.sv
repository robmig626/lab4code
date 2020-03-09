module FSM_shuffle_mem_testbench();
	reg start, clk, reset;
	wire fin, sum_en, swap_en, read_key, read_s, wr_en, inc_en;
	
	FSM_shuffle_mem DUT(
	.start(start),
	.fin(fin),
	.clk(clk),
	.reset(reset),
	.read_s(read_s),
	.read_key(read_key),
	.sum_en(sum_en),
	.wr_en(wr_en),
	.inc_en(inc_en),
	.swap_en(swap_en));
	
	initial begin
		forever begin
			clk = 1'b0;
			#5;
			clk = 1'b1;
			#5;
		end
	end
	
	initial begin
		start= 1'b1;
		reset = 1'b1;
		#10;
		reset = 1'b0;
		#300;
	end
endmodule 
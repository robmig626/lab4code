module FSM_shuffle_mem(start,
 fin,
 clk,
 reset,
 read_s,
 read_key,
 sum_en,
 wr_en_si,
 addr_to_sj,
 wr_en_sj,
 swap_en,
 inc_en);
	//state encoding
	parameter idle          = 9'b000000000;
	parameter read_memories = 9'b000000110;//implement as flip_flops in top_level
	parameter sum_j         = 9'b000001000; // j is the address for shuffling
	parameter swap_si_sj    = 9'b000010000;
	parameter shuffle_wr_en_si = 9'b000000001;
	parameter switch_to_addr_sj =9'b100000000;
	parameter shuffle_wr_en_sj = 9'b010000000;
	parameter inc_addr_i    = 9'b001000000;
	parameter finish        = 9'b000100000;
	
	input start, clk, reset;
	output fin, sum_en, swap_en, wr_en_si, addr_to_sj, wr_en_sj, inc_en, read_key, read_s;
	
	reg [8:0] state;
	
	assign inc_en = state[6];
	assign fin = state[5];
	assign swap_en = state[4];
	assign sum_en = state[3];
	assign read_s = state[2];
	assign read_key = state[1];
	assign wr_en_si = state[0];
	
	assign wr_en_sj = state[7];
	assign addr_to_sj = state[8];
	
	always_ff@(posedge clk) begin
	
	if (reset) state<=idle;
	else state<=state;
	
		case (state) 
			idle: if(start) state<=read_memories;
					else state<=idle;
					
			read_memories: state<=sum_j;
			
			sum_j: state<= swap_si_sj;
			
			swap_si_sj: state<=shuffle_wr_en_si;
			
			shuffle_wr_en_si: state<=switch_to_addr_sj;
			
			switch_to_addr_sj: state<=shuffle_wr_en_sj;
			
			shuffle_wr_en_sj: state<=inc_addr_i;
			
			inc_addr_i: state<=finish;
			
			finish: state<=idle;
		endcase
	end
//	
endmodule 
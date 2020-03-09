module FSM_shuffle_mem(start, fin, clk, reset, read_s, read_key, sum_en,wr_en, swap_en, inc_en);
	//state encoding
	parameter idle          = 7'b0000000;
	parameter read_memories = 7'b0000110;//implement as flip_flops in top_level
	parameter sum_j         = 7'b0001000; // j is the address for shuffling
	parameter swap_si_sj    = 7'b0010000;
	parameter shuffle_wr_en = 7'b0000001;
	parameter inc_addr_i    = 7'b1000000;
	parameter finish        = 7'b0100000;
	
	input start, clk, reset;
	output fin, sum_en, swap_en, wr_en, inc_en, read_key, read_s;
	
	reg [6:0] state;
	
	assign inc_en = state[6];
	assign fin = state[5];
	assign swap_en = state[4];
	assign sum_en = state[3];
	assign read_s = state[2];
	assign read_key = state[1];
	assign wr_en = state[0];
	
	always_ff@(posedge clk) begin
	
	if (reset) state<=idle;
	else state<=state;
	
		case (state) 
			idle: if(start) state<=read_memories;
					else state<=idle;
					
			read_memories: state<=sum_j;
			
			sum_j: state<= swap_si_sj;
			
			swap_si_sj: state<=shuffle_wr_en;
			
			shuffle_wr_en: state<=inc_addr_i;
			
			inc_addr_i: state<=finish;
			
			finish: state<=idle;
		endcase
	end
//	
endmodule 
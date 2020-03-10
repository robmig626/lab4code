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
	reg [7:0] counter = 8'h00;
	// the numbers are the order of the steps
	assign inc_en = state[6];   //8 this increments the address i
	assign fin = state[5];      //9 this is finish signal
	assign swap_en = state[4];  //4 this used to read from working memory sj
	assign sum_en = state[3];   //3 this computes the final value of 'j' address
	assign read_s = state[2];   //1 this reads the working memory si and stores in register
	assign read_key = state[1]; //1 this reads the secret_key memory and stores it in register
	assign wr_en_si = state[0]; //5 this writes what was at address sj to address si
	
	assign wr_en_sj = state[7]; //7 this writes what was at address si to address sj
	assign addr_to_sj = state[8]; //6 this changes address to be written to from si to sj
	
	always_ff@(posedge clk) begin
	
	if (reset) state<=idle;
	else state<=state;
	
		case (state) 
			idle: if(start) state<=read_memories; // wait for start
					else state<=idle;
					
			read_memories: state<=sum_j; //reads working mem at si, and key at imod3
			
			sum_j: state<= swap_si_sj; //computes value for j
			
			swap_si_sj: state<=shuffle_wr_en_si; //reads working mem at sj
			
			shuffle_wr_en_si: state<=switch_to_addr_sj; //writes to addr si the sj data
			
			switch_to_addr_sj: state<=shuffle_wr_en_sj; //switches addess to sj
			
			shuffle_wr_en_sj: state<=inc_addr_i; //writes to addr sj the previous si data
			
			inc_addr_i: if (counter == 8'hFF) state<=finish; // increments i by 1
									else begin
									counter<=counter+1;
									state<=read_memories;
									end
			
			finish: state<=idle; //done
		endcase
	end
//	
endmodule 
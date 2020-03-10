module flag_shuffle_op(
 clk,
 curr_addr, // address we want to write to or read from
 mem_s_read_data, // data coming from memory
 secret_key,
 
 write_data, //data we want to write to memory
 wr_en,

 read_s,
 read_key,
 sum_en,
 wr_en_si,
 addr_to_sj,
 wr_en_sj,
 swap_en,
 inc_en);
	
	input read_s, read_key, sum_en, wr_en_si, addr_to_sj, wr_en_sj, swap_en, inc_en, clk;
	input [7:0] mem_s_read_data;
	input [23:0] secret_key;
	
	output reg wr_en;
	output reg [7:0] write_data, curr_addr;
	
	reg[7:0] si_addr; // initialized at 0
	reg[7:0] sj_addr; // initialized at 0
	reg[7:0] read_si_data;
   reg[7:0] read_sj_data;
	reg[7:0] keyMod1,keyMod2,keyMod3;
	reg[7:0] key_mod_j;
	
	always_ff@(posedge read_key) begin // read the switches and select the byte used
		//wr_en <= 0;
		keyMod1 = secret_key[7:0];
		keyMod2 = secret_key[15:8];
		keyMod3 = secret_key[23:16];
		case(si_addr % 3)
			0:key_mod_j = keyMod1;
			1:key_mod_j = keyMod2;
			2:key_mod_j = keyMod3;
		endcase
	end
	
	always_ff@(posedge clk/*posedge read_s, posedge swap_en, posedge sum_en, posedge wr_en_si, posedge addr_to_sj, posedge wr_en_sj, posedge inc_en*/)
	 begin
		case({read_s, read_key, sum_en,wr_en_si,addr_to_sj,wr_en_sj,inc_en})
			7'b1000000: // read_s memory at address si
			 begin
			 	curr_addr <= si_addr;
				read_si_data <= mem_s_read_data;
				wr_en <= 0;
			 end

			 7'b0100000: // read_s memory at address sj
			 begin
			 	curr_addr <= sj_addr;
				read_sj_data <= mem_s_read_data;
				wr_en <= 0;
			 end
			
			7'b0010000: // compute address sj
			 begin
			 	wr_en <= 0;
				sj_addr = sj_addr + key_mod_j + read_si_data;
			 end

			7'b0001000: // write to address si data at sj
			 begin
			 	wr_en <= 1;
				curr_addr <= si_addr;
				write_data <= read_sj_data;
			 end

			7'b0000100: // change to addr sj and disable write while switching
			 begin
			 	wr_en <= 0;
				curr_addr <= sj_addr;
			 end

			7'b0000010: // write to address sj data at si
			 begin
			 	wr_en <= 1;
				curr_addr <= sj_addr;
				write_data <= read_si_data;
			 end


			7'b0000001: // increment address
			 begin
			 	wr_en <= 0;
				si_addr <= si_addr +1;
			 end

			default: // set to all zero
			 begin
			 	wr_en <= 0;
				curr_addr <= 0;
				write_data <= 0;
			 end

		endcase
	 end
endmodule 

/*
always_ff@(posedge read_s) begin // read_s memory at address si
		curr_addr <= si_addr;
		read_si_data <= mem_s_read_data;
		wr_en <= 0;
	end
	
	always_ff@(posedge swap_en) begin // read_s memory at address sj
		curr_addr <= sj_addr;
		read_sj_data <= mem_s_read_data;
		wr_en <= 0;
	end

always_ff@(posedge sum_en) begin // compute address sj
		wr_en <= 0;
		sj_addr = sj_addr + key_mod_j + read_si_data;
	end
	
	always_ff@(posedge wr_en_si) begin //write to address si data at sj
		wr_en <= 1;
		curr_addr <= si_addr;
		write_data <= read_sj_data;
	end
	
	always_ff@(posedge addr_to_sj) begin // change to addr sj and disable write while switching
		wr_en <= 0;
		curr_addr <= sj_addr;
	end
	
	always_ff@(posedge wr_en_sj) begin //write to address sj data at si
		wr_en <= 1;
		curr_addr <= sj_addr;
		write_data <= read_si_data;
	end
	
	always_ff@(posedge inc_en) begin // increment address
		wr_en <= 0;
		si_addr <= si_addr +1;
	end
	*/
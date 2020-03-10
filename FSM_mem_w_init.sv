module FSM_mem_w_init(rst,start, finish, clk, wr_en, mem_addr, wr_data);
	input clk, start, rst;
	
	output wr_en, finish;
	output [7:0] mem_addr, wr_data;

	parameter idle = 3'b000;
	parameter write_to_mem = 3'b001;
	parameter update_address = 3'b010;
	parameter finish_init = 3'b100;

	reg[7:0] address = 8'h00;
	reg [2:0] state;
	
	assign wr_en = state[0];
	assign finish = state[2];
	
	assign mem_addr = address;
	assign wr_data = address; //this is only for the first part of the code
	
	always_ff@(posedge clk) begin
	
	if (rst) begin state<= idle;end
	else 
	
		case(state)
			idle: if(start) state<=write_to_mem;
					else state<= idle;

			write_to_mem: state <= update_address;
			
			update_address:  if (address == 8'hFF) state<=finish_init; 
										 else begin 
										 address<= address+1; 
										 state<=write_to_mem;
										 end
								 
			finish_init: state<=idle;
		endcase
	end
endmodule 
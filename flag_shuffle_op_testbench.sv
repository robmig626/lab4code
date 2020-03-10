module flag_shuffle_op_tb ();

reg read_s, read_key, sum_en, wr_en_si, addr_to_sj, wr_en_sj, swap_en, inc_en;
reg [7:0] mem_s_read_data;
reg [23:0] secret_key;
	
wire wr_en;
wire [7:0] write_data, curr_addr;

flag_shuffle_op dut 
(
    .curr_addr(curr_addr), // address we want to write to or read from
    .mem_s_read_data(mem_s_read_data), // data coming from memory
    .secret_key(secret_key),
    .write_data(write_data), //data we want to write to memory
    .wr_en(wr_en),
    .read_s(read_s),
    .read_key(read_key),
    .sum_en(sum_en),
    .wr_en_si(wr_en_si),
    .addr_to_sj(addr_to_sj),
    .wr_en_sj(wr_en_sj),
    .swap_en(swap_en),
    .inc_en(inc_en)
);

initial 
 begin
	forever 
     begin
	     clk = 1'b0;
		 #5;
	     clk = 1'b1;
		 #5;
	 end
 end

 initial begin
     read_s = 1'b0;
     read_key = 1'b0;
     sum_en = 1'b0;
     wr_en_si = 1'b0;
     addr_to_sj = 1'b0;
     wr_en_sj = 1'b0;
     swap_en = 1'b0;
     inc_en = 1'b0;

     #10;

     
 end
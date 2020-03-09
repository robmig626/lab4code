module state_machine_control_testbench();

reg clk, reset, start, finish;
reg finish_init, finish_shuffle;
reg write_enable_init, write_enable_shuffle;
reg [7:0] address_init, address_shuffle;
reg [7:0] write_data_init, write_data_shuffle;

wire start_init, start_shuffle;
wire write_enable_out;
wire [7:0] address_out;
wire [7:0] write_data_out;

state_machine_control dut
(
    .clk(clk),
    .reset(reset),
    .start(start),
    .finish(finish),
    .start_init(start_init),
    .finish_init(finish_init),
    .start_shuffle(start_shuffle),
    .finish_shuffle(finish_shuffle),
    .write_enable_init(write_enable_init),
    .write_enable_shuffle(write_enable_shuffle),
    .write_enable_out(write_enable_out),
    .address_init(address_init),
    .address_shuffle(address_shuffle),
    .address_out(address_out),
    .write_data_init(write_data_init),
    .write_data_shuffle(write_data_shuffle),
    .write_data_out(write_data_out)
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

 initial 
  begin
     reset = 1'b1;
     start = 1'b1;

  end


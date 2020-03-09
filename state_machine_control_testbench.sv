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


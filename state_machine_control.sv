module state_machine_control
(
    clk,
    rst,
    start_init,
    finish_init,
    start_shuffle,
    finish_shuffle,
    write_enable_init,
    write_enable_shuffle,
    address_init,
    address_shuffle,
    address_out,
    write_data_init,
    write_data_shuffle,
    write_enable_out
);

input clk, rst;
input finish_init, finish_shuffle;
input write_data_init, write_enable_shuffle;
input [7:0] 
module ksa (input CLOCK_50,
    input KEY[3:0],
    input [9:0] SW,
    output LEDR[9:0],
    output HEX0[6:0],
    output HEX1[6:0],
    output HEX2[6:0],
    output HEX3[6:0],
    output HEX4[6:0],
    output HEX5[6:0]);

    wire clk;

    wire q, write_enable;
    wire [7:0] address, write_data;

    wire start_control, finish_control;

    wire start_init, finish_init, write_enable_init;
    wire [7:0] address_init, write_data_init;

    wire start_shuffle, finish_shuffle;
    wire read_s, read_key, sum_en, wr_en_si, addr_to_sj, wr_en_sj, swap_en, inc_en;

    assign clk = CLOCK_50;
    assign start_control = 1'b1;

    FSM_mem_w_init FSM1
    (
        .clk(clk),
        .rst(1'b0),
        .start(start_init),
        .finish(finish_init),
        .wr_en(write_enable_init),
        .mem_addr(address_init),
        .wr_data(write_data_init)
    );

    FSM_shuffle_mem FSM2
    (
        .start(start_shuffle),
        .fin(finish_shuffle),
        .clk(clk),
        .reset(1'b0),
        .read_s(read_s),
        .read_key(read_key),
        .sum_en(sum_en),
        .wr_en_si(wr_en_si),
        .addr_to_sj(addr_to_sj),
        .wr_en_sj(wr_en_sj),
        .swap_en(swap_en),
        .inc_en(inc_en)
    );

    //add some stuff to control write_enable, address, and write_data based on flags

    state_machine_control enableFSMs
    (
        .clk(clk),
        .reset(1'b0),
        .start(start_control),
        .finish(finish_control),
        .start_init(start_init),
        .finish_init(finish_init),
        .start_shuffle(start_shuffle),
        .finish_shuffle(finish_shuffle),
        .write_enable_init(write_enable_init),
        .write_enable_shuffle(write_enable_shuffle),
        .write_enable_out(write_enable),
        .address_init(address_init),
        .address_shuffle(address_shuffle),
        .address_out(address),
        .write_data_init(write_data_init),
        .write_data_shuffle(write_data_shuffle),
        .write_data_out(write_data)
    );

    s_memory mem
    (
        .address(address),
        .clock(clk),
        .data(write_data),
        .wren(write_enable),
        .q(q)
    );

endmodule 


    
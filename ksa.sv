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

    wire clk, reset;
    wire [6:0] ssOut;
    wire [3:0] nIn;
	wire [9:0] switches;

    //s_memory
    wire q, write_enable;
    wire [7:0] address, write_data;

    // encrypt_mem, decrypt_mem
    wire [7:0] address_m, q_m, address_d, q_d, data_d;
	wire wren_d;

    //FSM control
    wire start_control, finish_control;

    // init state machine
    wire start_init, finish_init, write_enable_init;
    wire [7:0] address_init, write_data_init;

    // shuffle state machine
    wire start_shuffle, finish_shuffle;
    wire read_s, read_key, sum_en, wr_en_si, addr_to_sj, wr_en_sj, swap_en, inc_en;

    assign clk = CLOCK_50;
    assign switches = SW;
    assign start_control = 1'b1;
    assign reset = 1'b0;

    SevenSegmentDisplayDecoder mod (.nIn(nIn), .ssOut(ssOut));

    FSM_mem_w_init FSM1
    (
        .clk(clk),
        .rst(reset),
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
        .reset(reset),
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
        .reset(reset),
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
    /*
    encrypted_message emem
    (
        .address(address_m), 
        .clock(clk), 
        .q(q_m)
    );
	*//*
	 decrypted_message dmem
     (
         .address(address_d), 
         .clock(clk), 
         .data(data_d), 
         .wren(wren_d), 
         .q(q_d)
    );
    */
endmodule 


    
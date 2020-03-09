module state_machine_control
(
    clk,
    reset,
    start,
    finish,
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

input wire clk, reset, start, finish;
input wire finish_init, finish_shuffle;
input wire write_enable_init, write_enable_shuffle;
input wire [7:0] address_init, address_shuffle;
input wire [7:0] write_data_init, write_data_shuffle;

output wire start_init, start_shuffle;
output logic write_enable_out;
output logic [7:0] address_out;
output logic [7:0] write_data_out;

logic [11:0] state;

wire init_select, shuffle_select;

parameter idle                      = 12'b0000_00000000;
parameter start_init                = 12'b0001_00000011;
parameter wait_for_finish_init      = 12'b0010_00000010;
parameter start_shuffle             = 12'b0011_00001100;
parameter wait_for_finish_shuffle   = 12'b0100_00001000;
parameter give_finish_bit           = 12'b0101_10000000;

assign start_init                   = state[0];
assign init_select                  = state[1];
assign start_shuffle                = state[2];
assign shuffle_select               = state[3];
assign finish                       = state[7];

always_comb
 begin
     case({init_select, shuffle_select})
        2'b10:
         begin
             write_enable_out = write_data_init;
             address_out = address_init;
             write_data_out = write_data_init;
         end
         2'b01:
         begin
             write_enable_out = write_data_shuffle;
             address_out = address_shuffle;
             write_data_out = write_data_shuffle;
         end
         default:
          begin
             write_enable_out = 1'b0;
             address_out = 8'b0;
             write_data_out = 8'b0;
          end
     endcase
 end

 always_ff @(posedge clk, posedge reset)
  begin
     if(reset)
         state <= idle;
     else
      begin
         case(state)
            idle:
             begin
                 if(start)
                    state <= start_init;
             end
            
            start_init: state <= wait_for_finish_init;

            wait_for_finish_init:
             begin
                 if(finish_init)
                    state <= start_shuffle;
             end

            start_shuffle: state <= wait_for_finish_shuffle;

            wait_for_finish_shuffle:
             begin
                 if(finish_shuffle)
                    state <= give_finish_bit;
             end

            give_finish_bit: state <= idle;
         endcase
      end
  end

endmodule
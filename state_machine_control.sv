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
    write_enable_out,
    address_init,
    address_shuffle,
    address_out,
    write_data_init,
    write_data_shuffle,
    write_data_out
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

parameter idle                      = 12'b0000_00000000; //wait for the start bit
parameter start_init_FSM            = 12'b0001_00000011; //send the start bit to the first state machine
parameter wait_for_finish_init      = 12'b0010_00000010; //wait until the first state machine is finished
parameter start_shuffle_FSM         = 12'b0011_00001100; //after the first state machine has finished send the start bit to the second state machine
parameter wait_for_finish_shuffle   = 12'b0100_00001000; //wait for the second state machine to finish
parameter give_finish_bit           = 12'b0101_10000000; //after all the state machines have finished send the finish bit

assign start_init                   = state[0]; //start state machine 1 bit
assign init_select                  = state[1]; //select the parameters for state machine 1
assign start_shuffle                = state[2]; //start state machine 2 bit
assign shuffle_select               = state[3]; //select the parameters for state machine 2
assign finish                       = state[7]; //finish bit


// selects the write_enable, address, and data that is sent to the memory based on what state machine is currently running
always_comb
 begin
     case({init_select, shuffle_select})
        2'b10:
         begin
             write_enable_out = write_enable_init; //select the parametrs for state machine 1
             address_out = address_init;
             write_data_out = write_data_init;
         end
         2'b01:
         begin
             write_enable_out = write_enable_shuffle; //select the parameters for state machine 2
             address_out = address_shuffle;
             write_data_out = write_data_shuffle;
         end
         default:
          begin
             write_enable_out = 1'b0; //if no state machine is running then set write_enable, address and write_data to 0
             address_out = 8'b0;
             write_data_out = 8'b0;
          end
     endcase
 end

 always_ff @(posedge clk, posedge reset)
  begin
     if(reset)
         state <= idle; //set state to idle if reset
     else
      begin
         case(state)
            idle: // wait until the start bit has been set, after starting move to the start state machine 1 state
             begin
                 if(start)
                    state <= start_init_FSM;    
             end
            
            start_init_FSM: state <= wait_for_finish_init; // start state machine 1, move to the wait for state machine 1 to finish state

            wait_for_finish_init: // wait until the state machine 1 finished bit is high, then move to the start state machine 2 state
             begin
                 if(finish_init)
                    state <= start_shuffle_FSM; 
             end

            start_shuffle_FSM: state <= wait_for_finish_shuffle; // start state machine 2, move to wait for state machine 2 to finish state

            wait_for_finish_shuffle: // wait until the state machine 2 finished bit is high, then move to the finished state 
             begin
                 if(finish_shuffle)
                    state <= give_finish_bit;
             end

            give_finish_bit: state <= idle; // set the finish bit high, then set the state back to idle
         endcase
      end
  end

endmodule
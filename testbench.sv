module tb;
  logic clk;
  logic reset;
  logic start;
  logic [7:0] data_in;
  logic [7:0] data_out;
  logic tx_valid;
  logic status_complete;
  
  
  
  Protocol_State_Tracker DUT(
    .clk(clk),
    .reset(reset),
    .start(start),
    .data_in(data_in),
    .data_out(data_out),
    .tx_valid(tx_valid),
    .status_complete(status_complete)
  ); 
  	//clk functionality
  always #1 clk = ~clk;
  
  initial begin
    
    //monitors the state, reset, if started, data out, tx_valid and if status is completed
    $monitor("Time: %d | State: %s | clk: %d | reset: %d | start: %d | tx: %d | rx: %d | tx valid: %d | complete: %d", $time, DUT.current_state.name(), clk, reset, start, data_in, data_out, tx_valid, status_complete);
    clk = 0; 
    reset = 1;
    start = 0;
    data_in = 8'd45;
    #1
    reset = 0;
    #2
    start = 1;
    #20
    $finish;
  end
endmodule

/*
Time:                    0 | State: IDLE | clk: 0 | reset: 1 | start: 0 | tx:  45 | rx:   0 | tx valid: 0 | complete: 0
Time:                    1 | State: IDLE | clk: 1 | reset: 0 | start: 0 | tx:  45 | rx:   0 | tx valid: 0 | complete: 0
Time:                    2 | State: IDLE | clk: 0 | reset: 0 | start: 0 | tx:  45 | rx:   0 | tx valid: 0 | complete: 0
Time:                    3 | State: SETUP | clk: 1 | reset: 0 | start: 1 | tx:  45 | rx:   0 | tx valid: 0 | complete: 0
Time:                    4 | State: SETUP | clk: 0 | reset: 0 | start: 1 | tx:  45 | rx:   0 | tx valid: 0 | complete: 0
Time:                    5 | State: SETUP | clk: 1 | reset: 0 | start: 1 | tx:  45 | rx:   0 | tx valid: 0 | complete: 0
Time:                    6 | State: SETUP | clk: 0 | reset: 0 | start: 1 | tx:  45 | rx:   0 | tx valid: 0 | complete: 0
Time:                    7 | State: SETUP | clk: 1 | reset: 0 | start: 1 | tx:  45 | rx:   0 | tx valid: 0 | complete: 0
Time:                    8 | State: SETUP | clk: 0 | reset: 0 | start: 1 | tx:  45 | rx:   0 | tx valid: 0 | complete: 0
Time:                    9 | State: SETUP | clk: 1 | reset: 0 | start: 1 | tx:  45 | rx:   0 | tx valid: 0 | complete: 0
Time:                   10 | State: SETUP | clk: 0 | reset: 0 | start: 1 | tx:  45 | rx:   0 | tx valid: 0 | complete: 0
Time:                   11 | State: DATA | clk: 1 | reset: 0 | start: 1 | tx:  45 | rx:   0 | tx valid: 1 | complete: 0
Time:                   12 | State: DATA | clk: 0 | reset: 0 | start: 1 | tx:  45 | rx:   0 | tx valid: 1 | complete: 0
Time:                   13 | State: DONE | clk: 1 | reset: 0 | start: 1 | tx:  45 | rx:  45 | tx valid: 0 | complete: 0
Time:                   14 | State: DONE | clk: 0 | reset: 0 | start: 1 | tx:  45 | rx:  45 | tx valid: 0 | complete: 0
Time:                   15 | State: IDLE | clk: 1 | reset: 0 | start: 1 | tx:  45 | rx:  45 | tx valid: 0 | complete: 1
Time:                   16 | State: IDLE | clk: 0 | reset: 0 | start: 1 | tx:  45 | rx:  45 | tx valid: 0 | complete: 1
Time:                   17 | State: SETUP | clk: 1 | reset: 0 | start: 1 | tx:  45 | rx:  45 | tx valid: 0 | complete: 0
Time:                   18 | State: SETUP | clk: 0 | reset: 0 | start: 1 | tx:  45 | rx:  45 | tx valid: 0 | complete: 0
Time:                   19 | State: SETUP | clk: 1 | reset: 0 | start: 1 | tx:  45 | rx:  45 | tx valid: 0 | complete: 0
Time:                   20 | State: SETUP | clk: 0 | reset: 0 | start: 1 | tx:  45 | rx:  45 | tx valid: 0 | complete: 0
Time:                   21 | State: SETUP | clk: 1 | reset: 0 | start: 1 | tx:  45 | rx:  45 | tx valid: 0 | complete: 0
Time:                   22 | State: SETUP | clk: 0 | reset: 0 | start: 1 | tx:  45 | rx:  45 | tx valid: 0 | complete: 0
/*

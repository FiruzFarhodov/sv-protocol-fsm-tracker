module Protocol_State_Tracker(
  input              clk,
  input 	         reset,
  input 		     start,
  input        [7:0] data_in,
  output logic [7:0] data_out,
  output logic       tx_valid,
  output logic 		 status_complete
);
  
  // used for bridging the gap between blocking and non-blocking
  bit [7:0] next_data_out; 
  bit next_status_complete;
  bit next_tx_valid;
  bit [1:0] counter;
  bit two_cycles_completed;
  
  // defines the different states
  typedef enum logic [3:0] {IDLE = 4'b0000, SETUP = 4'b0011, DATA = 4'b1000, DONE = 4'b1100 , ERROR = 4'b1111} states; 
  
  states current_state, next_state;
  
  always_ff @(posedge clk or posedge reset)  begin
    //initialize output values at the start
    if(reset) begin
      current_state <= IDLE;
	  data_out <= 0;
	  tx_valid <= 0;
      status_complete <= 0;
    end
    else begin
      status_complete <= next_status_complete;
      tx_valid <= next_tx_valid;
      current_state <= next_state;
      data_out <= next_data_out;
      
      if(current_state == SETUP) begin
        if(counter < 2) begin
          counter <= counter + 1;
          two_cycles_completed <= 0;
        end
        else begin
        counter <= 0;
          two_cycles_completed <= 1;
        end
      end else begin
        counter <= 0;
        two_cycles_completed <= 0;
      end
    end   
  end
  
  
  always_comb begin
    
    next_state = current_state;
    next_data_out = data_out;
    next_tx_valid = 0;
    next_status_complete = 0;
    
    case(current_state)
    
      IDLE : begin
        if(start) begin
        next_state = SETUP;
        end
        if(tx_valid) begin
          next_state = ERROR;
        end
      end
      
      SETUP : begin  // must be in setup for two cycles
        if(two_cycles_completed) begin
          next_tx_valid = 1;
          next_state = DATA;
        end else begin
          next_tx_valid = 0;
          next_state = SETUP;
        end
      end
      
      DATA : begin  
        // if the tx is valid then the data is transmitted
        if(tx_valid) begin
          next_data_out = data_in;
          next_state = DONE;
          // if not it waits until tx_valid is true
        end else begin
          next_data_out = 0;  
          next_state = DATA;
        end
      end
      
      DONE : begin
        // signals completion and loops back to idle, and setting tx to false
        next_status_complete = 1;
        next_tx_valid = 0;
        next_state = IDLE;
      end
     
      ERROR : begin
        next_tx_valid = 0;
       	next_state = IDLE; 
      end
      
      default: begin
        // default case
        next_state           = IDLE;
        next_tx_valid        = 0;
        next_status_complete = 0;
      end
    
    endcase
  end
 
endmodule 

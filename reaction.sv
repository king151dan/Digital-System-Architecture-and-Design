module reaction(
  input logic clk, reset,
  input logic ss,
  output logic go,
  output logic [31:0] reactionTime
);

  // Instantiate the clock divider module
  clk1kHz clkDivider(.clk(clk), .reset(reset), .clkout());

  // Instantiate the millisecond counter module
  mscnt msCounter(.clk(clkDivider.clkout), .reset(reset), .cnt(reactionTime));

  // Instantiate the FSM module
  fsm stateMachine(.clk(clk), .reset(reset), .ss(ss), .cnt(reactionTime), .go(go), .capture());

endmodule
//

module fsm(
  input logic clk, reset,
  input logic ss,
  input logic [31:0] cnt,
  output logic go, capture
);
  //state enumeration
  typedef enum logic [1:0] {
    IDLE, WAITING, OUTPUT, CAPTURE
  } state_t;

  //state and next state signals
  state_t state, next_state;

  //state registers
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // next state logic
  always_comb begin
    case (state)
      IDLE:
        if (ss) begin
          next_state = WAITING;
        end else begin
          next_state = IDLE;
        end
      WAITING:
        if (cnt == 0) begin
          next_state = OUTPUT;
        end else begin
          next_state = WAITING;
        end
      OUTPUT:
        if (ss) begin
          next_state = CAPTURE;
        end else begin
          next_state = OUTPUT;
        end
      CAPTURE:
        if (ss) begin
          next_state = IDLE;
        end else begin
          next_state = CAPTURE;
        end
    endcase
  end

  //output logic
  always_comb begin
    case (state)
      IDLE, WAITING: begin 
        go = 0;
        capture = 0; end 
      OUTPUT: begin 
        go = 1;
        capture = 0; end 
      CAPTURE: begin 
        go = 0;
        capture = 1; end 
    endcase
  end
endmodule
//

module clk1kHz(input logic clk, reset,
               output logic clkout);

  // Internal counter for dividing the clock frequency
  logic [3:0] counter;

  // Output clock
  assign clkout = counter[3];

  // Clock divider process
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      counter <= 4'b0;
    end else begin
      if (counter == 4'b1001) begin
        counter <= 4'b0;
      end else begin
        counter <= counter + 1;
      end
    end
  end

endmodule
//

module mscnt(input logic clk, reset,
             output logic [31:0] cnt);

  // Internal counter
  logic [31:0] counter;

  // Millisecond counter process
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      counter <= 32'b0;
    end else begin
      counter <= counter + 1;
    end
  end

  // Output assignment
  assign cnt = counter;

endmodule
//



module reaction_tb;
  // Testbench inputs
  reg clk;
  reg reset;
  reg ss;

  // Testbench outputs
  wire go;
  wire [31:0] reactionTime;

  // Instantiate the reaction module
  reaction dut (
    .clk(clk),
    .reset(reset),
    .ss(ss),
    .go(go),
    .reactionTime(reactionTime)
  );

  // Clock generation
  always #5 clk = ~clk;
  always #100 ss = ~ss;
always #125 reset = ~reset;
//always #20 reset = ~reset;

  // Initialize signals
  initial begin
    clk = 0;
    reset = 1;
    ss = 0;
    #10 reset = 0;
    #20 ss = 1; // Start the reaction timer
    #100;
    ss = 0; // Press 'ss' to capture reaction time
    #100;
    ss = 1; // Release 'ss' to restart the timer
    #200;
    ss = 0; // Press 'ss' to capture reaction time
    #100;
  
  end


  // Print reaction time and 'go' signal changes
  always @(posedge clk) begin
    if (go)
      $display("[TIME=%t] go asserted", $time);
    if (reactionTime != 0)
      $display("[TIME=%t] Reaction Time: %0d", $time, reactionTime);
  end

endmodule


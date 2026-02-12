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
          next_state = WAITING;
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

module fsm_testbench();
  logic        clk, reset, ss;
  logic [31:0] cnt;
  logic        go, capture;

  // instantiate device under test
  fsm dut(clk, reset, ss, cnt, go, capture);

  // generate clock
  always 
    begin
      clk = 1; #5; clk = 0; #5;
    end

  // initialize inputs and observe outputs
  initial
    begin
      reset = 1; ss = 0; cnt = 0;
      #27;
      reset = 0; ss = 1; cnt = 1000;
      #50;
      ss = 0; cnt = 0;
      #30;
      ss = 1;
      #50;
      ss = 0;
      #30;
      $finish;
    end
endmodule

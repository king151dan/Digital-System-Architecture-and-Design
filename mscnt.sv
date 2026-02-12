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


module tb_mscnt();
  logic clk, reset;
  logic [31:0] cnt;

  // Instantiate the mscnt module
  mscnt dut(
    .clk(clk),
    .reset(reset),
    .cnt(cnt)
  );

  // Generate clock signal
  always #5 clk = ~clk;
always #25 reset = ~reset;


  // Toggle reset and observe cnt
  initial begin
    reset = 1;
clk= 0 ;
cnt = 0 ;
    #20;
    reset = 0;
    #100;
    //$finish;
  end

endmodule

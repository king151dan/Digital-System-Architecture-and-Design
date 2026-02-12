
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


module tb_clk1kHz();
  logic clk, reset, clkout;

  // Instantiate the clk1kHz module
  clk1kHz dut(
    .clk(clk),
    .reset(reset),
    .clkout(clkout)
  );

  // Generate clock signal
  always #.5 clk = ~clk;

always #15 reset = ~reset;

  // Toggle reset and observe clkout
  initial begin
    reset = 1;
clk = 1;
    #10;
    reset = 0;
   #300;
   //$finish;
  end

endmodule

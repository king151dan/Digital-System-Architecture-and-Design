
module alu_testbench();
  logic clk, reset;
  logic [31:0] A, B, Result;
  logic [2:0] ALUControl;
  logic [31:0] vectornum, errors;
  logic [31:0] testvectors[1000:0];

  // Instantiate device under test
  alu dut(.A, .B, .ALUControl, .Result);

  // Generate clock
  always begin
    clk = 1; #5; clk = 0; #5;
  end

  // At the start of the test, load vectors
  // and pulse reset
  initial begin
    $readmemh("alu.txt", testvectors);

    vectornum = 0; errors = 0;
    reset = 1; #27; reset = 0;
  end

  // Apply test vectors on the rising edge of clk
  always @(posedge clk) begin
    #1;
    {ALUControl, A, B} = testvectors[vectornum];
  end

  // Check results on the falling edge of clk
  always @(negedge clk) begin
    if (~reset) begin // Skip during reset
      if (dut.Result !== testvectors[vectornum][31:0]) begin // Check result
        $display("Error: ALUControl = %h, A = %h, B = %h", ALUControl, A, B);
        $display("  Result = %h (%h expected)", dut.Result, testvectors[vectornum][31:0]);
        errors = errors + 1;
      end
      vectornum = vectornum + 1;
      if (testvectors[vectornum] === 4'bx) begin
        $display("%d tests completed with %d errors", vectornum, errors);
        $finish;
      end
    end
  end
endmodule



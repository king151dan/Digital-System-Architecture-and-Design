module alu(
  input logic [31:0] A,
  input logic [31:0] B,
  input logic [2:0] ALUControl,
  output logic [31:0] Result
);
  // Internal signals
  logic [31:0] sum;
  logic [31:0] difference;
  logic [31:0] bitwise_and;
  logic [31:0] bitwise_or;
  logic [31:0] bitwise_xor;
  logic [31:0] slt_result;

  // ALU functionality
  always_comb begin
    case (ALUControl)
      3'b000: begin // Add
        sum = A + B;
        Result = sum;
      end
      3'b001: begin // Subtract
        difference = A - B;
        Result = difference;
      end
      3'b010: begin // And
        bitwise_and = A & B;
        Result = bitwise_and;
      end
      3'b011: begin // Or
        bitwise_or = A | B;
        Result = bitwise_or;
      end
      3'b100: begin // And
        bitwise_and = A ^ B;
        Result = bitwise_xor;
      end
      3'b101: begin // SLT (Set Less Than)
        if (A < B)
          slt_result = 32'b1;
        else
          slt_result = 32'b0;
        Result = slt_result;
      end
      default: begin // Invalid ALUControl value
        Result = 32'b0;
      end
    endcase
  end
endmodule
// 




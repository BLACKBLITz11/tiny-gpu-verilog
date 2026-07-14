module alu (
    input  [3:0]  op,      // operation selector
    input  [15:0] a,       // first number
    input  [15:0] b,       // second number
    output reg [15:0] result  // answer
);

always @(*) begin
    case(op)
        4'b0000: result = a + b;  // ADD
        4'b0001: result = a - b;  // SUB
        4'b0010: result = a * b;  // MUL
        4'b0011: result = a & b;  // AND
        4'b0100: result = a | b;  // OR
        default: result = 16'h0;  // anything else = 0
    endcase
end

endmodule
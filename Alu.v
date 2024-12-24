module alu (
    input [31:0] a,          // Operand A
    input [31:0] b,          // Operand B
    input [3:0] alu_control, // ALU operation control
    output reg [31:0] result // ALU result
);

    always @(*) begin
        case (alu_control)
            4'b0000: result = a + b;         // ADD
            4'b0001: result = a - b;         // SUB
            4'b0010: result = a & b;         // AND
            4'b0011: result = a | b;         // OR
            4'b0100: result = a << b[4:0];   // SLL (Shift Left)
            4'b0101: result = a >> b[4:0];   // SRL (Shift Right)
            4'b0110: result = a < b ? 1 : 0; // SLT (Set Less Than)
            4'b0111: result = a * b;         // MUL (Multiplication)
            4'b1000: result = a / b;         // DIV (Division)
            default: result = 32'b0;
        endcase
    end
endmodule
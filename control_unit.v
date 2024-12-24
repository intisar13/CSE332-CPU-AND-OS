module control_unit (
    input [5:0] opcode,       // opcode from instruction
    output reg reg_dst,       // select register destination
    output reg branch,        // branch control
    output reg mem_read,      // memory read control
    output reg mem_to_reg,    // memory to register control
    output reg alu_op,        // ALU operation control
    output reg mem_write,     // memory write control
    output reg alu_src,       // ALU source control
    output reg reg_write,     // register write control
    output reg jump,          // jump control
    output reg jal,           // Jump and Link control
    output reg jr             // Jump Register control
);

    always @(*) begin
        case (opcode)
            6'b000000: begin // R-type instructions
                reg_dst = 1;
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                alu_op = 1;  // ALU operation for R-type instructions
                mem_write = 0;
                alu_src = 0;
                reg_write = 1;
                jump = 0;
                jal = 0;
                jr = 0;
            end

            6'b000010: begin // J-type: Jump (J)
                reg_dst = 0;
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                alu_op = 0;
                mem_write = 0;
                alu_src = 0;
                reg_write = 0;
                jump = 1;
                jal = 0;
                jr = 0;
            end

            6'b000011: begin // JAL (Jump and Link)
                reg_dst = 0;
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                alu_op = 0;
                mem_write = 0;
                alu_src = 0;
                reg_write = 1;  // Write return address to $ra (register 31)
                jump = 1;
                jal = 1;
                jr = 0;
            end

            6'b000100: begin // BEQ (Branch if equal)
                reg_dst = 0;
                branch = 1;
                mem_read = 0;
                mem_to_reg = 0;
                alu_op = 0; // Compare two registers
                mem_write = 0;
                alu_src = 0;
                reg_write = 0;
                jump = 0;
                jal = 0;
                jr = 0;
            end

            6'b000001: begin // JR (Jump Register)
                reg_dst = 0;
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                alu_op = 0;
                mem_write = 0;
                alu_src = 0;
                reg_write = 0;
                jump = 0;
                jal = 0;
                jr = 1;
            end

            // More cases can be added for other instructions like LW, SW, ADDI, etc.

            default: begin
                reg_dst = 0;
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                alu_op = 0;
                mem_write = 0;
                alu_src = 0;
                reg_write = 0;
                jump = 0;
                jal = 0;
                jr = 0;
            end
        endcase
    end
endmodule

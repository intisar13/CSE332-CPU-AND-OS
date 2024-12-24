module cpu_tb;

    reg clk;
    reg reset;
    reg [31:0] instruction;
    reg [31:0] read_data_mem;
    wire [31:0] pc;
    wire [31:0] read_data;
    wire [31:0] alu_result; // Declare alu_result wire
    wire [31:0] write_data; // Declare write_data wire
    wire [4:0] write_reg;   // Declare write_reg wire
    wire reg_write;         // Declare reg_write wire
    wire mem_read;          // Declare mem_read wire
    wire mem_write;         // Declare mem_write wire
    wire alu_src;           // Declare alu_src wire
    wire reg_dst;           // Declare reg_dst wire
    wire mem_to_reg;        // Declare mem_to_reg wire
    wire pc_src;            // Declare pc_src wire
    wire jump;              // Declare jump wire
    wire zero;              // Declare zero wire
    wire [1:0] alu_op;      // Declare alu_op wire

    // Instantiate the CPU components (datapath, control, ALU)
    datapath uut_datapath(
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .read_data_mem(read_data_mem),
        .alu_result(alu_result),
        .write_data(write_data),
        .write_reg(write_reg),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_dst(reg_dst),
        .mem_to_reg(mem_to_reg),
        .pc_src(pc_src),
        .jump(jump),
        .pc(pc),
        .read_data(read_data)
    );

    control_unit uut_control(
        .opcode(instruction[31:26]),
        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .pc_src(pc_src),
        .jump(jump),
        .alu_op(alu_op)
    );

    alu uut_alu(
        .input1(read_data),
        .input2(alu_input), // Ensure alu_input is defined
        .alu_op(alu_op),
        .result(alu_result),
        .zero(zero)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        clk = 0;
        reset = 1;
        instruction = 32'h0; // Load initial instruction
        read_data_mem = 32'h0;

        // Release reset
        #10 reset = 0;

        // Test JAL instruction
        instruction = 32'b00001100000000000000000000000100; // Example JAL instruction
        #10;

        // Test JR instruction
        instruction = 32'b00000000000000000000000000000100; // Example JR instruction
        #10;

        // Test division subroutine
        instruction = 32'b00000000000000000000000000000101; // Example division instruction
        #10;

        // Continue the tests // Add more test cases as needed
        // For example, testing other instructions or edge cases
        instruction = 32'b00000000000000000000000000001010; // Example instruction
        #10;

        // Finalize the simulation
        $stop;
    end

endmodule
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Define constants for line and instruction limits
#define MAX_LINE_LENGTH 100
#define MAX_OPCODE_LENGTH 10

// Define the instruction structure
typedef struct {
    char mnemonic[MAX_OPCODE_LENGTH];
    char opcode[6]; // 5-bit opcode (binary string)
    int type;       // 0 = R-type, 1 = I-type, 2 = J-type
} Instruction;

// Define the register structure
typedef struct {
    char name[5];  // Register name (e.g., $0, $1)
    char code[6];  // Binary representation (5-bit)
} Register;

// Define ISA for instructions
Instruction instruction_set[] = {
    {"addi", "00100", 1},
    {"xori", "00110", 1},
    {"add", "00000", 0},
    {"sub", "00001", 0},
    {"slt", "00010", 0},
    {"or", "00011", 0},
    {"and", "00111", 0},
    {"sll", "01000", 0},
    {"srl", "01001", 0},
    {"li", "10000", 1},
    {"lw", "10011", 1},
    {"sw", "10100", 1},
    {"jump", "00010", 2},
    {"jal", "00011", 2}
};

// Define registers
Register register_set[] = {
    {"$0", "00000"},
    {"$1", "00001"},
    {"$2", "00010"},
    {"$3", "00011"},
    {"$4", "00100"},
    {"$5", "00101"},
    {"$6", "00110"},
    {"$7", "00111"},
    {"$8", "01000"},
    {"$9", "01001"},
    {"$10", "01010"},
    {"$11", "01011"},
    {"$12", "01100"},
    {"$13", "01101"},
    {"$14", "01110"},
    {"$15", "01111"},
    {"$16", "10000"},
    {"$17", "10001"},
    {"$18", "10010"},
    {"$19", "10011"},
    {"$20", "10100"},
    {"$21", "10101"},
    {"$22", "10110"},
    {"$23", "10111"},
    {"$24", "11000"},
    {"$25", "11001"},
    {"$26", "11010"},
    {"$27", "11011"},
    {"$28", "11100"},
    {"$29", "11101"},
    {"$30", "11110"},
    {"$31", "11111"}
};

// Find opcode for a mnemonic
const char* get_opcode(const char* mnemonic) {
    for (int i = 0; i < sizeof(instruction_set) / sizeof(Instruction); i++) {
        if (strcmp(instruction_set[i].mnemonic, mnemonic) == 0) {
            return instruction_set[i].opcode;
        }
    }
    return NULL; // Not found
}

// Find binary code for a register
const char* get_register_code(const char* reg) {
    for (int i = 0; i < sizeof(register_set) / sizeof(Register); i++) {
        if (strcmp(register_set[i]. name, reg) == 0) {
            return register_set[i].code;
        }
    }
    return NULL; // Not found
}

// Convert immediate value to binary
void immediate_to_binary(int immediate, char* binary, int bits) {
    for (int i = bits - 1; i >= 0; i--) {
        binary[i] = (immediate % 2) + '0';
        immediate /= 2;
    }
    binary[bits] = '\0'; // Null-terminate the string
}

// Parse and assemble a single line
void assemble_line(const char* line, char* output) {
    char mnemonic[MAX_OPCODE_LENGTH], reg1[5], reg2[5], reg3[5];
    int immediate;
    char binary_imm[17]; // 16-bit immediate

    // Initialize the output binary string
    memset(output, 0, MAX_LINE_LENGTH);

    // Check for instruction format (R-type)
    if (sscanf(line, "%s %[^,], %[^,], %[^,]", mnemonic, reg1, reg2, reg3) == 4) {
        const char* opcode = get_opcode(mnemonic);
        const char* r1_code = get_register_code(reg1);
        const char* r2_code = get_register_code(reg2);
        const char* r3_code = get_register_code(reg3);

        if (!opcode || !r1_code || !r2_code || !r3_code) {
            fprintf(stderr, "Error: Invalid instruction or register in line: %s\n", line);
            return; // Continue processing
        }

        sprintf(output, "%s%s%s%s", opcode, r1_code, r2_code, r3_code);
    }
    // Check for instruction format (I-type)
    else if (sscanf(line, "%s %[^,], %[^,], %d", mnemonic, reg1, reg2, &immediate) == 4) {
        const char* opcode = get_opcode(mnemonic);
        const char* r1_code = get_register_code(reg1);
        const char* r2_code = get_register_code(reg2);

        if (!opcode || !r1_code || !r2_code) {
            fprintf(stderr, "Error: Invalid instruction or register in line: %s\n", line);
            return; // Continue processing
        }

        immediate_to_binary(immediate, binary_imm, 16);
        sprintf(output, "%s%s%s%s", opcode, r1_code, r2_code, binary_imm);
    }
    // Check for instruction format (I-type with single register and immediate)
    else if (sscanf(line, "%s %[^,], %d", mnemonic, reg1, &immediate) == 3) {
        const char* opcode = get_opcode(mnemonic);
        const char* r1_code = get_register_code(reg1);

        if (!opcode || !r1_code) {
            fprintf(stderr, "Error: Invalid instruction or register in line: %s\n", line);
            return; // Continue processing
        }

        immediate_to_binary(immediate, binary_imm, 16);
        sprintf(output, "%s%s%s", opcode, r1_code, binary_imm);
    }
    // Check for instruction format (J-type)
    else if (sscanf(line, "%s %d", mnemonic, &immediate) == 2) {
        const char* opcode = get_opcode(mnemonic);
        if (!opcode) {
            fprintf(stderr, "Error: Invalid instruction in line: %s\n", line);
            return; // Continue processing
        }

        immediate_to_binary(immediate, binary_imm, 26); // Convert to 26 bits for J-type
        sprintf(output, "%s%s", opcode, binary_imm);
    } else {
        fprintf(stderr, "Error: Unsupported instruction format in line: %s\n", line);
        return; // Continue processing
    }
}

// Assemble the entire file
void assemble_file(const char* input_file, const char* output_file) {
    FILE *input, *output;
    char line[MAX_LINE_LENGTH];
    char binary_output[MAX_LINE_LENGTH];

    input = fopen(input_file, "r");
    if (!input) {
        perror("Error opening input file");
        exit(1);
    }

    output = fopen(output_file, "w");
    if (!output) {
        perror("Error opening output file");
        fclose(input);
        exit(1);
    }

    while (fgets(line, MAX_LINE_LENGTH, input)) {
        // Remove newline character
        line[strcspn(line, "\n")] = '\0';

        // Skip empty lines
        if (strlen(line) == 0 || line[0] == '.') continue;

        // Assemble the line
        assemble_line(line, binary_output);

        // Write the binary output to the file if not empty
        if (strlen(binary_output) > 0) {
            fprintf(output, "%s\n", binary_output);
        }
    }

    fclose(input);
    fclose(output);
}

// Main function
int main(int argc, char* argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <input.asm> <output.bin>\n", argv[0]);
        return 1;
    }

    assemble_file(argv[1], argv[2]);

    printf("Assembly completed. Output written to %s\n", argv[2]);
    return 0;
}

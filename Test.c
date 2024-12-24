#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Function to execute a shell command and return the output
int execute_command(const char *command) {
    int result = system(command);
    return result;
}

// Function to compare the output binary with the expected output
int compare_output(const char* output_file, const char* expected_output) {
    FILE *output = fopen(output_file, "r");
    FILE *expected = fopen(expected_output, "r");

    if (!output || !expected) {
        fprintf(stderr, "Error opening files for comparison.\n");
        return 1;
    }

    char output_line[100];
    char expected_line[100];
    while (fgets(output_line, sizeof(output_line), output)) {
        fgets(expected_line, sizeof(expected_line), expected);

        // Remove the newline characters from both output and expected
        output_line[strcspn(output_line, "\n")] = '\0';
        expected_line[strcspn(expected_line, "\n")] = '\0';

        if (strcmp(output_line, expected_line) != 0) {
            fprintf(stderr, "Mismatch found:\nExpected: %s\nGot: %s\n", expected_line, output_line);
            fclose(output);
            fclose(expected);
            return 1;
        }
    }

    fclose(output);
    fclose(expected);
    return 0;
}

// Function to run a single test case
void run_test_case(const char *input_file, const char *expected_output_file, const char *output_file) {
    // Run the assembler program
    char command[256];
    snprintf(command, sizeof(command), "./assembler %s %s", input_file, output_file);
    if (execute_command(command) != 0) {
        fprintf(stderr, "Assembler failed to run for input: %s\n", input_file);
        return;
    }

    // Compare the generated output with the expected output
    if (compare_output(output_file, expected_output_file) == 0) {
        printf("Test passed for %s\n", input_file);
    } else {
        printf("Test failed for %s\n", input_file);
    }
}

int main() {
    // Create the input and expected output files for the test cases
    FILE *test_case_1 = fopen("test_case_1.asm", "w");
    FILE *expected_output_1 = fopen("expected_output_1.bin", "w");

    if (!test_case_1 || !expected_output_1) {
        fprintf(stderr, "Error creating test files\n");
        return 1;
    }

    // Example test case: addi, sub, jump instructions
    fprintf(test_case_1, "addi $1, $2, 10\n");
    fprintf(test_case_1, "sub $3, $4, $5\n");
    fprintf(test_case_1, "jump 100\n");

    // Expected binary output for the test case (you need to manually create these values based on your expected output)
    fprintf(expected_output_1, "00100000001000010000000000001010\n");
    fprintf(expected_output_1, "00001000010001010000100000000000\n");
    fprintf(expected_output_1, "00010000000000000000000000000000\n");

    fclose(test_case_1);
    fclose(expected_output_1);

    // Output file for the assembler's result
    const char *output_file = "output.bin";

    // Run the test case
    run_test_case("test_case_1.asm", "expected_output_1.bin", output_file);

    // Clean up generated files
    remove("test_case_1.asm");
    remove("expected_output_1.bin");
    remove(output_file);

    return 0;
}

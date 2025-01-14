module testbench;
    reg clock;
    reg reset;
    reg [3:0] number;
    wire error_led;
    wire [1:0] state_display;

    // Instantiating the state machine
    state_machine uut (
        .clock(clock),
        .reset(reset),
        .number(number),
        .error_led(error_led),
        .state_display(state_display)
    );

    // Generating the clock
    always begin
        #5 clock = ~clock;  // Generate clock with 10-unit period
    end

    // Variables for file reading
    integer i;
    reg [3:0] sequence [5:0]; // Array to store input sequence

    // Testbench process
    initial begin
        // Initialization
        clock = 0;
        reset = 1;
        number = 4'b0000;

        // Reset the machine
        #10 reset = 0;

        // Load the sequence from the file
        $readmemb("input_sequence.txt", sequence, 0, 5);

        // Display the sequence
        $display("Starting robot sequence...");

        // Iterate through the sequence
        for (i = 0; i < 6; i = i + 1) begin
            number = sequence[i]; // Assign the number from the array
            #10; // Wait for state update

            // Debugging output
            $display("Number: %d, State Display: %b, Error LED: %b", number, state_display, error_led);
            $display("Current State: %b", uut.state);

            if (state_display == 2'b11)
                $display("Game over: Too many errors.");
            else if (state_display == 2'b01)
                $display("Partial success: Continuing...");
            else if (state_display == 2'b10)
                $display("Sequence completed successfully!");
        end

        // End simulation
        $finish;
    end
endmodule

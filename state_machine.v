module state_machine (
    input clock,
    input reset,
    input [3:0] number,
    output reg error_led,
    output reg [1:0] state_display
);

    // Define states as parameters (4 bits)
    parameter q0 = 4'b0000, q1 = 4'b0001, q2 = 4'b0010, q3 = 4'b0011,
              q4 = 4'b0100, q5 = 4'b0101, q6S = 4'b0110, Partial = 4'b0111, Error = 4'b1000;

    reg [3:0] state, next_state; // State variables now 4 bits
    reg [1:0] error_count; // Counter to track the number of errors

    // Expected sequence: 5, 7, 5, 1, 6, 4
    parameter [3:0] N0 = 4'd5, N1 = 4'd7, N2 = 4'd5, N3 = 4'd1, N4 = 4'd6, N5 = 4'd4;

    // Initialize the state and error count
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            state <= q0; // Start in the initial state
            error_led <= 1'b0; // No error at the beginning
            state_display <= 2'b00; // Initial display state
            error_count <= 2'b00; // Reset error count
        end else begin
            state <= next_state; // Move to the next state
        end
    end

    // State transition logic
    always @(*) begin
        next_state = state;
        case (state)
            q0: begin
                if (number == N0) next_state = q1; 
                else begin
                    next_state = Partial;
                end
            end
            q1: begin
                if (number == N1) next_state = q2; 
                else begin
                    next_state = Partial;
                end
            end
            q2: begin
                if (number == N2) next_state = q3; 
                else begin
                    next_state = Partial;
                end
            end
            q3: begin
                if (number == N3) next_state = q4; 
                else begin
                    next_state = Partial;
                end
            end
            q4: begin
                if (number == N4) next_state = q5; 
                else begin
                    next_state = Partial;
                end
            end
            q5: begin
                if (number == N5) next_state = q6S; 
                else begin
                    next_state = Partial;
                end
            end
            q6S: begin
                next_state = q6S; // Success state
            end
            Partial: begin
                if (number == N0 || number == N1 || number == N2 || number == N3 || number == N4 || number == N5) 
                    next_state = state + 1; // Continue if the correct number is entered
                else if (error_count == 2'b01) 
                    next_state = Error; // If already one error, go to Error state
                else
                    next_state = Partial; // Stay in Partial state
            end
            Error: begin
                next_state = Error; // Stay in Error state on multiple errors
            end
        endcase
    end

    // Output logic
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            error_led <= 1'b0;
            state_display <= 2'b00;
            error_count <= 2'b00;
        end else begin
            case (state)
                q6S: state_display <= 2'b10; // Success state
                Partial: begin
                    error_led <= 1'b1; // Turn on error LED in partial state
                    state_display <= 2'b01; // Indicate partial success
                    error_count <= error_count + 1'b1; // Increment error count
                end
                Error: begin
                    error_led <= 1'b1; // Turn on error LED
                    state_display <= 2'b11; // Indicate error state
                end
                default: begin
                    error_led <= 1'b0; // No error
                    state_display <= 2'b00; // Waiting for next number
                end
            endcase
        end
    end

endmodule



module state_machine (
    input clock,
    input reset,
    input insere,
    input [3:0] number,
    output reg error_led,
    output reg [6:0] display_num,
    output reg [6:0] display_state,
    output reg perdeu
);

    reg [3:0] state, next_state;

    parameter q0 = 4'b0000, q1 = 4'b0001, q2 = 4'b0010, q3 = 4'b0011,
              q4 = 4'b0100, q5 = 4'b0101, q0S = 4'b0110, q1S = 4'b0111,
              q2S = 4'b1000, q3S = 4'b1001, q4S = 4'b1010, q5S = 4'b1011,
              sucessoparcial = 4'b1100, falha = 4'b1101, sucessolindo = 4'b1110;

    parameter [3:0] N0 = 4'd5, N1 = 4'd7, N2 = 4'd5, N3 = 4'd1, N4 = 4'd6, N5 = 4'd4;

    always @(*) begin
        case (state)
            q0: display_state = 7'b1000000; 
            q1: display_state  = 7'b1111001;
            q2: display_state  = 7'b0100100;
            q3: display_state  = 7'b0110000;
            q4: display_state  = 7'b0011001;
            q5: display_state  = 7'b0010010;
            q0S: display_state = 7'b1000000;
            q1S: display_state  = 7'b1111001;
            sucessoparcial: display_state = 7'b0001100;
            q2S: display_state  = 7'b0100100;
            q3S: display_state  = 7'b0110000;
            q4S: display_state  = 7'b0011001;
            q5S: display_state  = 7'b0010010;
            sucessolindo: display_num = 7'b0010010;
            
            falha: display_state = 7'b0001110;
            default: display_state = 7'b0010010; // "S" de sucesso
        endcase

        // Mostrando o número inserido no display
        case (number)
            4'b0000: display_num = 7'b1000000; // 0
            4'b0001: display_num = 7'b1111001; // 1
            4'b0010: display_num = 7'b0100100; // 2
            4'b0011: display_num = 7'b0110000; // 3
            4'b0100: display_num = 7'b0011001; // 4
            4'b0101: display_num = 7'b0010010; // 5
            4'b0110: display_num = 7'b0000010; // 6
            4'b0111: display_num = 7'b1111000; // 7
            4'b1000: display_num = 7'b0000000; // 8
            4'b1001: display_num = 7'b0010000; // 9
            default: display_num = 7'b1111111; // Desliga o display para valores inválidos
        endcase
    end

    // Bloco sequencial: Atualiza o estado e conta os erros
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            state <= q0;
        end else begin
            state <= next_state; 
        end
    end

    always @(*) begin
        if (insere == 0) begin
            case (state)
                q0: begin
                    if (number == N0) begin
                        next_state = q1;  
                        error_led = 1;
                    end else if (number != N0) begin
                        next_state = q0S;
                        error_led = 0;
                    end else begin
                        next_state = q0;
                    end
                end

                q1: begin
                    if (number == N1) begin
                        next_state = q2; 
                        error_led = 1; 
                    end else if (number != N1) begin
                        next_state = q1S;
                        error_led = 0; 
                    end else begin
                        next_state = q1;
                    end
                end

                q2: begin
                    if (number == N2) begin
                        next_state = q3;  
                        error_led = 1; 
                    end else if (number != N2) begin
                        next_state = q2S;
                        error_led = 0;  
                    end else begin
                        next_state = q2;
                    end
                end

                q3: begin
                    if (number == N3) begin
                        next_state = q4;
                        error_led = 1; 
                    end else if (number != N3) begin
                        next_state = q3S;
                        error_led = 0;
                    end else begin
                        next_state = q3S;
                    end
                end

                q4: begin
                    if (number == N4) begin
                        next_state = q5;
                        error_led = 1;
                    end else if (number != N4) begin
                        next_state = q4S;
                        error_led = 0;
                    end else begin
                        next_state = q4;
                    end
                end

                q5: begin
                    if (number == N5) begin
                        error_led = 1;
                        next_state = sucessolindo;
                        display_num = 7'b0010010;
                    end else if (number != N5) begin
                        next_state = q5S;
                        error_led = 0;
                    end else begin
                        next_state = q5;
                    end
                end

                sucessolindo: begin
                    next_state = sucessolindo;
                end

                q0S: begin
                    if (number == N0) begin
                        next_state = q1S;
                    end else if (number != N0) begin
                        next_state = falha;
                        error_led = 0;
                    end else begin
                        next_state = q0S;
                    end
                end

                q1S: begin
                    if (number == N1) begin
                        next_state = q2S;
                    end else if (number != N1) begin
                        next_state = falha;
                        error_led = 0;
                    end else begin
                        next_state = q1S;
                    end
                end

                q2S: begin
                    if (number == N2) begin
                        next_state = q3S;
                    end else if (number != N3) begin
                        next_state = falha;
                        error_led = 0;
                    end else begin
                        next_state = q2S;
                    end
                end

                q3S: begin
                    if (number == N3) begin
                        next_state = q4S;
                    end else if (number != N3) begin
                        next_state = falha;
                        error_led = 0;
                    end else begin
                        next_state = q3S;
                    end
                end

                q4S: begin
                    if (number == N4) begin
                        next_state = q5S;
                    end else if (number != N4) begin
                        next_state = falha;
                        error_led = 0;
                    end else begin
                        next_state = q4S;
                    end
                end

                q5S: begin
                    if (number == N5) begin
                        next_state = sucessoparcial;
                    end else if (number != N5) begin
                        next_state = falha;
                        error_led = 0;
                    end else begin
                        next_state = q5S;
                    end
                end

                sucessoparcial: begin
                    next_state = sucessoparcial;
                end

                falha: begin
                    next_state = falha;
                end

                default: begin
                    next_state = q0;
                end
            endcase
        end else begin
            next_state = state;
        end
    end
    always @(posedge clock) begin
            $display("Numero inserido: %d, estado atual: %d, proximo estado %d, Error_led: %d", number, state, next_state, error_led);
    end
    
endmodule
module state_machine_tb;

   
    reg clock;
    reg reset;
    reg insere;
    reg [3:0] number;
    wire [6:0] display_num;
    wire [6:0] display_state;
    wire error_led;

    
    state_machine dut (
        .clock(clock),
        .reset(reset),
        .insere(insere),
        .number(number),
        .display_num(display_num),
        .display_state(display_state),
        .error_led(error_led)
    );

   
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    
    initial begin
       
        reset = 1;
        insere = 1;
        #10;

        
        reset = 0;
        insere = 0;

       
    
        number = 4'b0101; // Número correto: 5
        #10;
        
        number = 4'b0111; // Número correto: 7
        #10;

        
        
        number = 4'b0101; // Número correto: 5
        #10;
        
        number = 4'b0001; // Número correto: 1
        #10;
        
        number = 4'b0110; // Número correto: 6
        #10;
        
        number = 4'b0100; // Número correto: 4
        #20;
        

        
        $display("Estado atual: %d", dut.state); 

        $finish;
    end

endmodule


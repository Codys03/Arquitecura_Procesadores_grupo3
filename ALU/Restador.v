

module Restador(
    input [3:0] A, 
    input [3:0] B,
    output [3:0] Resultado,  // Resultado en binario positivo
    output Signo,  // Indicador de signo: 0 = positivo, 1 = negativo
    input  sel,
    output C_out  // Carry out
);
    reg [3:0] resul;
    wire [3:0] Suma;
    integer i;

    always @(*) begin  
        // Calcular complemento a uno de B si sel es 1
        for (i = 0; i < 4; i = i + 1) begin
            resul[i] = B[i] ^ sel;
        end
    end

    // Instanciar el sumador de 4 bits
    sum4b S (.A(A), .B(resul), .Ci(sel), .Cout(C_out), .Sum(Suma));

    // El signo se determina por el valor de C_out
    assign Signo = ~C_out;  // Si C_out es 0, significa que hubo borrow, y el resultado es negativo

    // Si el resultado es negativo, obtener el valor absoluto
    assign Resultado = (Signo) ? (~Suma + 1) : Suma;

endmodule
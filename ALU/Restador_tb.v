`include "Restador.v"
`timescale 1ns / 1ps

module Restador_tb();

    reg [3:0] A_tb;    // Minuendo, 4 bits
    reg [3:0] B_tb;    // Sustraendo, 4 bits
  
    wire Cout_tb;
    wire [3:0] res_tb; // Resultado, 4 bits
    wire signo;
    reg sel_tb;
  
    // Instanciar la Unidad Bajo Prueba (UUT)
    Restador uut (
      .A(A_tb), 
      .B(B_tb),  
      .C_out(Cout_tb), 
      .Resultado(res_tb),
      .sel(sel_tb),
      .Signo(signo)
    );
  
    initial begin
        // Inicializar A_tb y B_tb
        A_tb = 5'b00001; // Inicializa el minuendo en 1
        sel_tb = 1;
        //Bucle para incrementar A_tb y probar con diferentes valores de B_tb
        for (A_tb = 1; A_tb < 15; A_tb = A_tb + 1) begin
            for (B_tb = 0; B_tb < 15; B_tb = B_tb + 1) begin
               
                #5; // Esperar 5 unidades de tiempo

                $display("El valor de %d - %d = %d signo= %d", A_tb, B_tb, res_tb, signo);
            end
        end
       
        $finish;
    end

    initial begin: TEST_CASE
        $dumpfile("restador_tb.vcd");
        $dumpvars(-1, uut);
    end
  
endmodule

  
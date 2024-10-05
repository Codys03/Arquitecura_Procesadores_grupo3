`timescale 1ns / 1ps
`include "alu.v"

module alu_tb(); 

	reg clk;
    reg init;
	reg sel;
	reg [1:0] OP;
	reg [3:0] A;
	reg [3:0] B;

	wire [5:0] resul;
	wire done;
	wire C_out;
	wire signo;

	// Instantiate the Unit Under Test (UUT)
	alu uut(

		.clk(clk), 
		.A(A), 
		.B(B), 
		.OP(OP), 
		.sel(sel), 
		.init(init),
		.Signo(signo),
		.done(done),
		.C_out(C_out),
		.resul(resul)
    );

	always #1 clk = ~clk;
	
	initial begin
        clk = 1'b0;
        A = 4'b0;
        B = 4'b0;
		OP = 2'b0;
		sel = 1'b0;
		init = 1'b0;


	    #10 init = 1;
		sel = 1;
		//for(OP=0;OP<4;OP=OP+1)begin
		OP=0;

	    for (A = 0; A < 8; A= A + 1) begin
			for(B = 0; B < 8; B= B + 1)begin
        	#2; init = 1;
   	        #2; init = 0;
	    	#20 
	    	#5 $display("%d / %d + %d = %d / %d ", OP, A, B, resul,signo);
       		end
		end
	end

    initial begin: TEST_CASE
		$dumpfile("alu_tb.vcd");
		$dumpvars(-1, uut);
		#10000 $finish;
	end
	
	
endmodule

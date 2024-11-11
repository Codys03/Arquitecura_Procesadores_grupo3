
module mips_suma(
       
		input clk,   
      input [3:0] operador, 
		input rst,
		input RegWrite,
		//output [7:0] Suma, 
		output [13:0] dis
    );
	 
	 wire [31:0] salidamem;
	 wire [4:0] A;
	 wire [4:0] B;
	 wire [31:0] datw;
	 wire [4:0] addrW;
	 wire [5:0] op;
	 wire [31:0] datOutRb;
	 wire [31:0] datOutRa;
	 assign A = salidamem[25:21];
	 assign B = salidamem[20:16];
	 assign addrW = salidamem[15:11];
	 assign op = salidamem[5:0];
	
	 mem_ins mem(.addrRa({28'b0,operador}),.datOutRa(salidamem));
	 
	 BancoRegistro banco(.addrRa({28'b0,A}),.addrRb({28'b0,B}),.addrW(addrW),.datOutRa(datOutRa),.datOutRb(datOutRb),.datW(datw),.RegWrite(RegWrite),.clk(clk));
	 
	 alu(.clk(clk),.A(datOutRa), .B(datOutRb),.OP(op),.resul(datw));
	 
	 decoder deco(.num(datw[7:0]),.Sseg(dis));
	endmodule 
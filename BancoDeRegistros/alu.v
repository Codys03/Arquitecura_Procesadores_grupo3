
module alu(
			input clk,   
			input [4:0] A, 
			input [4:0] B, 
			input [3:0] OP, 
			output reg [31:0]resul

    );

	//reg [26:0] ceros;

    always @(*) begin
	  //ceros <= 0;
		case (OP)
			4'b0000: resul <= A + B;
			4'b0001: resul <= A - B;
			4'b0010: resul <= A & B;
			4'b0011: resul <= A * B;
			default: resul <= 'b00000;
		endcase
		//assign resuli = {27'b0 ,resul};
	end


endmodule
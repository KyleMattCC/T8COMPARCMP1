//BUSTY BITS
//Calalan, Sherwin
//Chua, Kyle
//Cruz, Miguel
//Tirona, Paul
module alu(
opA, opB, sel,
res,
z,c,v
);

input wire [31:0] opA, opB;
input wire [2:0] sel;
reg [32:0] dump;
output reg [31:0] res;
output reg z, c, v;


always @ (sel or opA or opB) begin
	if(sel == 3'b000) begin //Addition
		{c, res} =  opA + opB; //Addition with carry flag
		
		if(res == 32'd0) begin //Check for zero flag
			z <= 1'b1;
		end
		else begin
			z <= 1'b0;
		end
		
		if(opA[31:31] == 1'b0 && opB[31:31] == 1'b0 && res[31:31] == 1'b1) begin //Check for overflow flag
			v <= 1'b1;
		end
		else if(opA[31:31] == 1'b1 && opB[31:31] == 1'b1 && res[31:31] == 1'b0) begin
			v <= 1'b1;
		end
		else begin
			v <= 1'b0;
		end
	end
	
	else if(sel == 3'b001) begin //Subtraction
		res = opA - opB;
		
		c <= 1'b0;
		if(opB < opA) begin
			c <= 1'b1;
		end
		
		if(res == 32'd0) begin //Check for zero flag
			z <= 1'b1;
		end
		else begin
			z <= 1'b0;
		end
		
		if(opA[31:31] == 1'b1 && opB[31:31] == 1'b0 && res[31:31] == 1'b0) begin //Check for overflow flag
			v <= 1'b1;
		end
		else if(opA[31:31] == 1'b0 && opB[31:31] == 1'b1 && res[31:31] == 1'b1) begin
			v <= 1'b1;
		end
		else begin
			v <= 1'b0;
		end
	end
	
	else if(sel == 3'b010) begin //And
		res =  opA & opB; //Bitwise and operation
		
		if(res == 32'd0) begin //Check for zero flag
			z <= 1'b1;
		end
		else begin
			z <= 1'b0;
		end
		
		c <= 1'b0; //Deassert carry flag
		v <= 1'b0; //Deassert for overflow flag
	end
	
	else if(sel == 3'b011) begin //Or
		res =  opA | opB; //Bitwise or operation
		
		if(res == 32'd0) begin //Check for zero flag
			z <= 1'b1;
		end
		else begin
			z <= 1'b0;
		end
		
		c <= 1'b0; //Deassert carry flag
		v <= 1'b0; //Deassert overflow flag
	end
	
	else if(sel == 3'b100) begin //Not
		res = ~opA; //complement
		
		if(res == 32'd0) begin //Check for zero flag
			z <= 1'b1;
		end
		else begin
			z <= 1'b0;
		end
		
		c <= 1'b0; //Deassert carry flag
		v <= 1'b0; //Deassert overflow flag
	end 
end

endmodule

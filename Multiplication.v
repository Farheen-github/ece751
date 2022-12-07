//https://github.com/nishthaparashar/Floating-Point-ALU-in-Verilog/tree/master/Multiplication
module Multiplication(
		input [31:0] a_operand,
		input [31:0] b_operand,
		output Exception, Overflow, Underflow,
		output invalid,
		output [31:0] result
		);

// With FP multiplication only flags are Overflow and Underflow
// Invalid is a helping signal noting the operation should be voided as the inputs could not produce a 
// For underflow and overflow, results produce a NAN or s111_1111_1xxx_xxxx_...

wire sign, normalised, zero;
wire [8:0] exponent, sum_exponent;
wire [22:0] product_mantissa;

//--------------------------------------------------------------------------------------------------------------------------

// Sign Math
assign sign = a_operand[31] ^ b_operand[31];

//--------------------------------------------------------------------------------------------------------------------------

// Exception with INF/NAN
// Exception flag sets 1 if either one of the exponent is 255.
assign Exception = (&a_operand[30:23]) | (&b_operand[30:23]);

//--------------------------------------------------------------------------------------------------------------------------

// Mantisma math
mantisma_approx MANTISMA(a_operand[30:0], b_operand[30:0], normalised, product_mantissa);

//--------------------------------------------------------------------------------------------------------------------------

// If 
assign zero = ~(|a_operand[30:0] & |b_operand[30:0]);

//--------------------------------------------------------------------------------------------------------------------------

// Exponent Math
assign sum_exponent = a_operand[30:23] + b_operand[30:23];

assign exponent = sum_exponent - 8'd127 + normalised; // - bias + if normalized

//Exception Case when exponent reaches its maximu value that is 384.
assign Overflow = (exponent[8] & !exponent[7] & !zero); //If overall exponent is greater than 255 then Overflow condition.

//If sum of both exponents is less than 127 then Underflow condition.
assign Underflow = (exponent[8] & exponent[7] & !zero); 

assign result = (Exception) ? ({sign, 8'hFF,23'd0}) : // Output NAN
				(zero) ? ({sign, 31'd0}) :
				(Overflow) ? {sign, 8'hFF,23'd0} : // Output NAN
				(Underflow) ? {sign, 8'hFF,23'd0} : 
					{sign, exponent[7:0], product_mantissa};
					
assign invalid = Exception | Overflow | Underflow;

endmodule
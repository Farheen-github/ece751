module Mult_precise(a_operand,b_operand,Exception,Overflow,Underflow,
				result
		);

input [31:0] a_operand,b_operand;
output Exception,Overflow,Underflow;
output [31:0] result;

wire sign, normalised, zero;
wire [8:0] exponent, sum_exponent;
wire [22:0] product_mantissa;

//--------------------------------------------------------------------------------------------------------------------------

// Sign Math
assign sign = a_operand[31] ^ b_operand[31];

//--------------------------------------------------------------------------------------------------------------------------

// Exception with INF
//Exception flag sets 1 if either one of the exponent is 255.
assign Exception = (&a_operand[30:23]) | (&b_operand[30:23]);

//--------------------------------------------------------------------------------------------------------------------------

// Mantisma math
Mult_mant Mantisaa_drum(.a_operand(a_operand[30:0]), .b_operand(b_operand[30:0]), .normalised(normalised), .product_mantissa(product_mantissa));


//--------------------------------------------------------------------------------------------------------------------------

// zero find
assign zero = ~(|a_operand[30:0] & |b_operand[30:0]);

//--------------------------------------------------------------------------------------------------------------------------

// Exponent Math
assign sum_exponent = a_operand[30:23] + b_operand[30:23];

assign exponent = sum_exponent - 8'd127 + normalised; // - bias + if normalized



assign Overflow = (exponent[8] & !exponent[7] & !zero); //If overall exponent is greater than 255 then Overflow condition.
//Exception Case when exponent reaches its maximu value that is 384.

//If sum of both exponents is less than 127 then Underflow condition.
assign Underflow = (exponent[8] & exponent[7] & !zero); 

assign result = (Exception) ? (32'd0) :
				(zero) ? ({sign, 31'd0}) :
				(Overflow) ? {sign, 8'hFF,23'd0} : 
				(Underflow) ? {sign, 31'd0} : 
					{sign, exponent[7:0], product_mantissa};

endmodule


module Mult_mant(
		input [30:0] a_operand,
		input [30:0] b_operand,
		output normalised,
		output [22:0] product_mantissa
		);

wire product_round;
wire [23:0] operand_a, operand_b;
wire [47:0] product, product_normalised; //48 Bits

// Assigining significand values according to Hidden Bit.
//If exponent is equal to zero then hidden bit will be 0 for that respective significand else it will be 1
assign operand_a = (|a_operand[30:23]) ? {1'b1,a_operand[22:0]} : {1'b0,a_operand[22:0]};
assign operand_b = (|b_operand[30:23]) ? {1'b1,b_operand[22:0]} : {1'b0,b_operand[22:0]};

// Calc (approx here)
assign product = operand_a * operand_b;

// Can omit
assign product_round = |product_normalised[22:0];  //Ending 22 bits are OR'ed for rounding operation.

// Normalize signal
assign normalised = product[47] ? 1'b1 : 1'b0;	

// Normalize the product
assign product_normalised = (normalised) ? (product) : (product << 1);	//Assigning Normalised value based on 48th bit

//Final Manitssa.
assign product_mantissa = product_normalised[46:24] + (product_normalised[23] & product_round); 

endmodule
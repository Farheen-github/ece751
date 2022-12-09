
module Mult_mant_approx(
		input [30:0] a_operand,
		input [30:0] b_operand,
		output normalised,
		output [22:0] product_mantissa
		);

localparam r = 0;

wire product_round;
wire [47:0] product, product_normalised; //48 Bits
wire a_normal, b_normal;
wire [47:0] A, B, C, D;

// Check hidden bit
assign a_normal = (|a_operand[30:23]) ? 1'b1 : 1'b0;
assign b_normal = (|b_operand[30:23]) ? 1'b1 : 1'b0;

// for (X + M1)(Y + M2) => XY + XM2 + YM1 + M1M2
// Where A + B + C + D
assign A = (a_normal & b_normal) ? {1'b0, 1'b1, 46'd0} : {48'd0};
assign B = (a_normal) ? {2'd0, b_operand[22:0], 23'd0} : {48'd0};
assign C = (b_normal) ? {2'd0, a_operand[22:0], 23'd0} : {48'd0};

// Aprox this and we can do well
assign D = a_operand[22:0] * b_operand[22:0];

//for the sake of multiplication
//wire [22:r]a,b;
//wire [44-2*r-1:0]temp;

//assign a = a_operand[22:r];
//assign b = b_operand[22:r];
//assign temp = a*b;
//assign D = temp;


assign product = A + B + D + C;

// Can omit
assign product_round =  1'b0;//|product_normalised[22:0];  //Ending 22 bits are OR'ed for rounding operation.
 
// Normalize signal
assign normalised = product[47] ? 1'b1 : 1'b0;	

// Normalize the product
assign product_normalised = (normalised) ? (product) : (product << 1);	//Assigning Normalised value based on 48th bit

//Final Manitssa.
assign product_mantissa = product_normalised[46:24] + (product_normalised[23] & product_round);  

endmodule
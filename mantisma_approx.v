module mantisma_approx(
		input [30:0] a_operand,
		input [30:0] b_operand,
		output normalised,
		output [22:0] product_mantissa
		);

wire product_round;
wire [23:0] operand_a, operand_b;
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

assign product = A + B + D + C;

// Assigining significand values according to Hidden Bit.
//If exponent is equal to zero then hidden bit will be 0 for that respective significand else it will be 1
//assign operand_a = (|a_operand[30:23]) ? {1'b1,a_operand[22:0]} : {1'b0,a_operand[22:0]};
//assign operand_b = (|b_operand[30:23]) ? {1'b1,b_operand[22:0]} : {1'b0,b_operand[22:0]};

// Calc (approx here)
//assign product = operand_a * operand_b;

// Can omit
assign product_round = |product_normalised[22:0];  //Ending 22 bits are OR'ed for rounding operation.

// Normalize signal
assign normalised = product[47] ? 1'b1 : 1'b0;	

// Normalize the product
assign product_normalised = (normalised) ? (product) : (product << 1);	//Assigning Normalised value based on 48th bit

//Final Manitssa.
assign product_mantissa = product_normalised[46:24] + (product_normalised[23] & product_round); 
//assign product_mantissa = product_normalised[46:24]; 

endmodule
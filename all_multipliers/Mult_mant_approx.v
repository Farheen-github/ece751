
module Mult_mant_approx(
		input [30:0] a_operand,
		input [30:0] b_operand,
		output normalised,
		output [22:0] product_mantissa
		);

localparam r = 24;

wire product_round;
wire [23:0] hidden_a, hidden_b;
wire [47:0] product, product_normalised; //48 Bits
wire a_normal, b_normal;

// Check hidden bit
assign a_normal = (|a_operand[30:23]) ? 1'b1 : 1'b0;
assign b_normal = (|b_operand[30:23]) ? 1'b1 : 1'b0;

assign hidden_a = (a_normal) ? ({1'b1, a_operand[22:0]}) : ({1'b0, a_operand[22:0]});
assign hidden_b = (b_normal) ? ({1'b1, b_operand[22:0]}) : ({1'b0, b_operand[22:0]});

//for the sake of multiplication
genvar i;
wire [23:0] a, b;
generate 
for (i = 0; i < 24; i = i + 1) begin
	if (i > 23-r) begin
		assign a[i] = a_operand[i];
		assign b[i] = b_operand[i];
	end
	else begin
		assign a[i] = 1'b0;
		assign b[i] = 1'b0;
	end

end
endgenerate

assign product = a * b;

// Can omit
assign product_round =  1'b0;//|product_normalised[22:0];  //Ending 22 bits are OR'ed for rounding operation.
 
// Normalize signal
assign normalised = product[47] ? 1'b1 : 1'b0;	

// Normalize the product
assign product_normalised = (normalised) ? (product) : (product << 1);	//Assigning Normalised value based on 48th bit

//Final Manitssa.
assign product_mantissa = product_normalised[46:24] + (product_normalised[23] & product_round);  

endmodule

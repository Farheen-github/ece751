module Mult_all(a_operand,b_operand,Exception,Overflow,Underflow,
				Overflow_approx,Underflow_approx, 
				Overflow_drum,Underflow_drum,
				Overflow_foil,Underflow_foil,
				result, result_approx, result_drum, result_foil
		);

input [31:0] a_operand,b_operand;
output Exception,Overflow,Underflow,Overflow_approx,Underflow_approx, Overflow_drum,Underflow_drum,Overflow_foil,Underflow_foil;
output [31:0] result, result_approx, result_drum, result_foil;


//--------------------------------------------------------------------------------------------------------------------------

// Exception with INF
//Exception flag sets 1 if either one of the exponent is 255.
assign Exception = (&a_operand[30:23]) | (&b_operand[30:23]);

//--------------------------------------------------------------------------------------------------------------------------

// Mantisma math
Mult_precise DUT0(.a_operand(a_operand),.b_operand(b_operand),.Exception(),
		.Overflow(Overflow),.Underflow(Underflow),
		.result(result)
		);

Mult_approx DUT1(.a_operand(a_operand),.b_operand(b_operand),.Exception(),
		.Overflow(Overflow_approx),.Underflow(Underflow_approx),
		.result(result_approx)
		);

Mult_drum DUT2(.a_operand(a_operand),.b_operand(b_operand),.Exception(),
		.Overflow(Overflow_drum),.Underflow(Underflow_drum),
		.result(result_drum)
		);

Mult_foil DUT3(.a_operand(a_operand),.b_operand(b_operand),.Exception(),
		.Overflow(Overflow_foil),.Underflow(Underflow_foil),
		.result(result_foil)
		);

//--------------------------------------------------------------------------------------------------------------------------

endmodule

module Mult_tb;

reg [31:0] a_operand,b_operand;
wire Exception,Overflow,Underflow,Overflow_approx,Underflow_approx, Overflow_drum,Underflow_drum,Overflow_foil,Underflow_foil;
wire [31:0] result, result_approx, result_drum, result_foil;

reg clk = 1'b1;

integer fd;
integer wd0, wd1, wd2, wd3;
integer i;
reg [31:0] in1;
reg [31:0] in2;
reg [31:0] in3;

Mult_all DUT(.a_operand(a_operand),.b_operand(b_operand),.Exception(Exception),
		.Overflow(Overflow),.Underflow(Underflow),.Overflow_approx(Overflow_approx),.Underflow_approx(Underflow_approx), 
		.Overflow_drum(Overflow_drum),.Underflow_drum(Underflow_drum), .Overflow_foil(Overflow_foil),.Underflow_foil(Underflow_foil), 
		.result(result),.result_approx(result_approx), .result_drum(result_drum),.result_foil(result_foil)
		);


always clk = #5 ~clk;

initial
begin
// Open file
fd = $fopen("read.txt","r");
wd0 = $fopen("perf.txt","w");
wd1 = $fopen("aprrox.txt","w");
wd2 = $fopen("drum.txt","w");
wd3 = $fopen("foil.txt","w");

for (i = 0; i < 10000; i = i + 1) begin
	$fscanf(fd, "%b\n", in1);
	$fscanf(fd, "%b\n", in2);
	$fscanf(fd, "%b\n", in3);
	
	// Check
	iteration (in1, in2, in3, i);
	
	// write Outputs
	$fdisplay(wd0,"%b", result);
	$fdisplay(wd1,"%b", result_approx);
	$fdisplay(wd2,"%b", result_drum);
	$fdisplay(wd3,"%b", result_foil);
	
end

$stop;

end

task iteration(
input [31:0] operand_a,operand_b,
input [31:0] Expected_result,
input integer linenum 
);
begin
@(negedge clk)
begin
	a_operand = operand_a;
	b_operand = operand_b;
end

@(posedge clk);

end
endtask
endmodule

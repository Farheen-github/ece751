///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//File Name: Multiplication_tb.v
//Created By: Sheetal Swaroop Burada
//Date: 30-04-2019
//Project Name: Design of 32 Bit Floating Point ALU Based on Standard IEEE-754 in Verilog and its implementation on FPGA.
//University: Dayalbagh Educational Institute
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module multiplication_tb;

reg [31:0] a_operand,b_operand;
wire Exception,Overflow,Underflow;
wire [31:0] result;

reg clk = 1'b1;

integer fd;
integer wd;
integer i;
reg [31:0] in1;
reg [31:0] in2;
reg [31:0] in3;

Multiplication dut(a_operand,b_operand,Exception,Overflow,Underflow,result);

always clk = #5 ~clk;

initial
begin
// Open file
fd = $fopen("read.txt","r");
wd = $fopen("dump.txt","w");

for (i = 0; i < 100; i = i + 1) begin
	$fscanf(fd, "%b\n", in1);
	$fscanf(fd, "%b\n", in2);
	$fscanf(fd, "%b\n", in3);
	
	// Check
	iteration (in1, in2, in3, i);
	
	$fdisplay(wd,"%b",result);
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

@(posedge clk)
begin
if (Expected_result == result)
	$display ("Test Passed - %d",linenum);

else
	$display ("Test failed - Expected_result = %h, Result = %h - %d\n", Expected_result, result, linenum);
end
end
endtask
endmodule
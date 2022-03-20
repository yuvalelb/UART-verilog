module timer50u (clk, reset, enable, out1);
	parameter size = 'd13;
	input clk, reset, enable;
	output out1;
	reg [size-1:0] count;
	wire [size-1:0] countp1;
	wire eflag;
	
	parameter equal = 13'd2500;
	assign countp1 = count + 1;
	
	always @(posedge clk)
	begin
		if (reset)
			count <= 'd0;
		else if (enable)
			count <= countp1;
	end
	
	assign eflag = (count > equal) & ~reset;
	
	assign out1 = eflag;
	
endmodule
	
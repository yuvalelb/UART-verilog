module counter2ms(clk, rst, ena, out);
	input clk, rst, ena;
	output out;
	wire outIntra, aXor;
	wire [5:0] cntP1;
	reg [5:0] cnt;
	reg timerRst;
	timer50u intraTimer(.clk(clk), .reset(rst | timerRst), .enable(ena), .out1(outIntra));
	
	always @(posedge clk)
	begin
		if(rst)
		begin
			cnt <= 'd0;
			timerRst <= 'd0;
		end
		else if(outIntra & ena)
			begin 
				cnt <= cntP1;
				timerRst <= 'd1;
			end
		else 
			timerRst <= 'd0;
	end
	assign cntP1 = cnt + 'd1;
	assign aXor = (cnt > 6'd40) & ~rst;
	assign out = aXor;
endmodule
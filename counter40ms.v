module counter40ms (clk, reset, en, out);
	input clk, reset, en;
	output out;
	wire outIntra, aXor;
	wire [5:0] cntP1;
	reg [5:0] cnt;
	reg timerRst;
	
	assign cntP1 = cnt +'d1;
	
	counter2ms intracnt (.clk(clk), .rst(reset | timerRst), .ena(en), .out (outIntra));
	always @ (posedge clk)
	begin
		if (reset)
		begin
			cnt <='d0;
			timerRst <='d0;
		end
		else if (en & outIntra)
		begin
			cnt <= cntP1;
			timerRst <= 'd1;
		end
		else
			timerRst <= 'd0;
	end
	
	assign aXor = (cnt > 6'd20) & ~reset;
	assign out = aXor;
endmodule
		
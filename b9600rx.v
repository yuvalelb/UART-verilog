module b9600rx(clk, reset, sig);
	input clk,reset;
	output sig;
	`define m50rl 11'd372
	reg [11:0] cnt;
	wire [11:0] cntp1;
	reg sigr;
	assign cntp1 = cnt +1;
	
	always @(posedge clk)
	begin
		if (reset)
		begin
			cnt <= 0;
			sigr <= 0;
		end
		else
		begin
			cnt <= cntp1;
			if(cnt == `m50rl)
				sigr <= 1;
			else
				sigr <= 0;
		end
	end
	
	assign sig = sigr;
endmodule
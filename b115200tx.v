module b115200tx(clk, reset, sig);
	input clk,reset;
	output sig;
	`define m50th 'd217
	reg [7:0] cnt;
	wire [7:0] cntp1;
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
			if(cnt == `m50th)
				sigr <= 1;
			else
				sigr <= 0;
		end
	end
	
	assign sig = sigr;
endmodule
module controlTB();
	reg clk, reset, paritys, bauds, dls, rxo;
	wire txo, lcdeo;
	wire [9:0] lcdo;
	wire [2:0] led;

	
	control tb(.clk(clk), .reset(reset), .paritys(paritys), .bauds(bauds), .dls(dls), .rxo(rxo), .txo(txo), .lcdo(lcdo), .lcdeo(lcdeo), .led(led));
	
	
	initial
	begin
		reset <=1;
		clk <= 1;
		paritys <=0; 
		bauds <= 1;
		dls <= 1;
		rxo <= 1;
		#200 reset <= 0;
	end
	
	always #1 clk <= ~clk;
	
	always #868 rxo <= ~rxo;
		
endmodule
module control(clk, reset, paritys, bauds, dls, rxo, txo, lcdo, lcdeo, led);

	output [2:0] led;
	input clk, reset, dls, bauds, paritys, rxo;
	output [9:0]lcdo;
	output txo, lcdeo;
	
	reg [7:0] tx;
	wire valid, busylcd, busywr;
	reg parityreg, framereg, overunreg, xon, writeready, readenreg, lcdenreg;
	reg [2:0] newflag;
	reg [2:0] fifocn;
	reg [2:0] lcdfifocn;
	reg [2:0] txfifocn;
	reg [7:0] fifo0;
	reg [7:0] fifo1;
	reg [7:0] fifo2;
	reg [7:0] fifo3;
	reg [7:0] fifo4;
	reg [7:0] fifo5;
	reg [7:0] fifo6;
	reg [7:0] fifo7;
	wire baudso, dlso, parityso, readen, lcden , writeen, writeenregw;
	wire [2:0] fifocnp1;
	wire [2:0] lcdfifocnp1;
	wire [2:0] txfifocnp1;
	wire [7:0] rx;
	reg [7:0] data;
	
	
	
	assign fifocnp1 = fifocn +1;
	assign lcdfifocnp1 = lcdfifocn +1;
	assign txfifocnp1 = txfifocn +1;
	assign led[2] = framereg;
	assign led[1] = parityreg;
	assign led[0] = overunreg;
	assign baudso = bauds;
	assign dlso = dls;
	assign parityso = paritys;
	assign readen = readenreg;
	assign lcden = lcdenreg;
	assign writeen = writeenregw;
	assign writeenregw = (xon & writeready & ~busywr);
	
	Rx receiver(.reset(reset), .clk(clk), .readen(readen), .rx(rxo), .baudr(baudso), .ps(parityso), .dlr(dlso), .letter(rx), .valid(valid), .framee(framee), .paritye(paritye), .overrune(overune));
	Tx sender(.clk(clk), .rst(reset), .write_en(writeen), .data_in(tx), .data_out(txo), .busy(busywr), .baud_rate(baudso), .parity_switch(parityso), .data_length(dlso));
	LCDc LSD(.LCD(data), .LCDe(lcden), .busy(busylcd), .clk(clk), .reset(reset), .lettero(lcdo), .LSDew(lcdeo));
	

	
	always @(posedge clk)
	begin
		if (~reset)
		begin
			if (paritye)
				parityreg <= 1;
			if (overune)
				overunreg <= 1;
			if (framee)
				framereg <=1;
			if (busylcd)
				lcdenreg <=0;

			
			if (busywr)	
				writeready <= 0;
			
			if ((lcdfifocn != fifocn) & ~busylcd & ~lcden)
			begin
				case (lcdfifocn)
					0: data <= fifo0;
					1: data <= fifo1;
					2: data <= fifo2;
					3: data <= fifo3;
					4: data <= fifo4;
					5: data <= fifo5;
					6: data <= fifo6;
					default: data <= fifo7;
				endcase
				lcdfifocn <= lcdfifocnp1;
				lcdenreg <= 1;
			end
			else
				lcdenreg <= 0;
			
			
			if ((txfifocn != fifocn) & ~busywr & ~writeready)
			begin
				case (txfifocn)
					0: tx <= fifo0;
					1: tx <= fifo1;
					2: tx <= fifo2;
					3: tx <= fifo3;
					4: tx <= fifo4;
					5: tx <= fifo5;
					6: tx <= fifo6;
					default: tx <= fifo7;
				endcase
				txfifocn <= txfifocnp1;
				writeready <= 1;
			end
			else
				writeready <= 0;
			
			
			if(valid & ~paritye)
			begin

				readenreg <= 1;
				if (rx == 'd19)
					xon <=0;
				else if(rx == 'd17)
					xon <= 1;
				else if (newflag == fifocn)
				begin
					case (fifocn)
						0: fifo0 <= rx;
						1: fifo1 <= rx;
						2: fifo2 <= rx;
						3: fifo3 <= rx;
						4: fifo4 <= rx;
						5: fifo5 <= rx;
						6: fifo6 <= rx;
						default: fifo7 <= rx;
					endcase
					fifocn <= fifocnp1;
				end
				else
					newflag <= fifocn;
			end
			else
			begin
				readenreg <=0;
			end
			end
		else
		begin
			framereg <= 0;
			parityreg <=0;
			overunreg <=0;
			xon <= 1;
			writeready <= 0;
			lcdenreg <= 0;
			fifo0 <= 0;
			fifo1 <= 0;
			fifo2 <= 0;
			fifo3 <= 0;
			fifo4 <= 0;
			fifo5 <= 0;
			fifo6 <= 0;
			fifo7 <= 0;
			fifocn <= 0;
			lcdfifocn <= 0;
			txfifocn <= 0;
			newflag <=0;
		end
	end
endmodule
	
			
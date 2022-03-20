module Rx(reset, clk, readen, rx, baudr, ps, dlr, letter, valid, framee, paritye, overrune); 
	input reset, clk, readen, rx, dlr, ps, baudr;
	output [7:0] letter;
	output valid, framee, paritye, overrune;
	reg [6:0] pulses;
	reg [2:0] pcount;
	(* KEEP = "TRUE" *) reg [2:0] Bcalc;
	reg SB, Bvalid, bclkl, bclkh, SBe;
	reg [7:0] data;
	reg [2:0] Dcnt;
	reg [3:0] Bcnt;
	reg parity, validr;
	reg framereg, parityreg, overrunreg;
	wire bl,bh;
	wire [2:0]pcountp1;
	wire pxor;
	wire [2:0]Dcntp1;
	wire bclkln;
	wire [3:0] Bcntp1;
	reg bclkhez, bclklez, readenez;
	
	
	assign pcountp1 = pcount +1;
	assign pxor = parity;
	assign Dcntp1 = Dcnt +1;
	assign letter = data;
	assign bclkln = ~bclkl;
	assign bclkhn = ~bclkh;
	assign valid = validr;
	assign paritye = parityreg;
	assign framee = framereg;
	assign overrune = overrunreg;
	assign Bcntp1 = Bcnt +1;
	
	b9600rx baudlowrx (.clk(clk), .reset(reset | baudr | bl ), .sig(bl));
	b115200rx baudhighrx (.clk(clk), .reset(reset | ~baudr | bh), .sig(bh));
	
	
	always @(posedge clk)
	begin
		if (reset)
		begin
			Dcnt <='d0;
			pulses <=255;
			pcount <=0;
			Bcalc <=7;
			SB <=0;
			Bvalid <=0;
			bclkh <=0;
			bclkl <=0;
			parity <=0;
			framereg <=0;
			overrunreg <=0;
			parityreg <=0;
			validr <= 0;
			SBe <=0;
			Bcnt <=0;
		end
		else
		begin
			if (bl)
				bclkl <= bclkln;
			if (bh)
				bclkh <= bclkhn;
			
			if ((bclkl != bclklez) & bclkl == 1)
			begin
				bclklez <= bclkl;
				if (~baudr)
				begin
					case (pcount)
						
						0: begin
							pulses[0] <= rx;
							pcount <= pcountp1;
							Dcnt <= Dcntp1;
							Bcalc <=  pulses[1] + pulses[2] + pulses[3] + pulses[4] + pulses[5] + pulses[6] + rx;
						end
						1: begin
							pulses[1] <= rx;
							pcount <= pcountp1;
							Dcnt <= Dcntp1;
							Bcalc <= pulses[0]  + pulses[2] + pulses[3] + pulses[4] + pulses[5] + pulses[6] + rx;
						end
						2: begin
							pulses[2] <= rx;
							pcount <= pcountp1;
							Dcnt <= Dcntp1;
							Bcalc <= pulses[0] + pulses[1]  + pulses[3] + pulses[4] + pulses[5] + pulses[6] + rx;
						end
						3: begin
							pulses[3] <= rx;
							pcount <= pcountp1;
							Dcnt <= Dcntp1;
							Bcalc <= pulses[0] + pulses[1] + pulses[2] +  pulses[4] + pulses[5] + pulses[6] + rx;
						end
						4: begin
							pulses[4] <= rx;
							pcount <= pcountp1;
							Dcnt <= Dcntp1;
							Bcalc <= pulses[0] + pulses[1] + pulses[2] + pulses[3] +  pulses[5] + pulses[6] + rx;
						end
						5: begin
							pulses[5] <= rx;
							pcount <= pcountp1;
							Dcnt <= Dcntp1;
							Bcalc <= pulses[0] + pulses[1] + pulses[2] + pulses[3] + pulses[4] +  pulses[6] + rx;
						end
						default: begin
							pulses[6] <= rx;
							pcount <= 0;
							Dcnt <= Dcntp1;
							Bcalc <= pulses[0] + pulses[1] + pulses[2] + pulses[3] + pulses[4] + pulses[5] + rx; 
						end
					endcase
				end
			end
			else
				bclklez <= bclkl;
			
			
			if ((bclkh != bclkhez) & bclkh == 1)
			begin
				bclkhez <= bclkh;
				if (baudr)
				begin
					case (pcount)
						
						0: begin
							pulses[0] <= rx;
							pcount <= pcountp1;
							Dcnt <= Dcntp1;
							Bcalc <= pulses[1] + pulses[2] + pulses[3] + pulses[4] + pulses[5] + pulses[6] + rx;
						end
						1: begin
							pulses[1] <= rx;
							pcount <= pcountp1;
							Dcnt <= Dcntp1;
							Bcalc <= pulses[0] + pulses[2] + pulses[3] + pulses[4] + pulses[5] + pulses[6] + rx;
						end
						2: begin
							pulses[2] <= rx;
							pcount <= pcountp1;
							Dcnt <= Dcntp1;
							Bcalc <= pulses[0] + pulses[1] + pulses[3] + pulses[4] + pulses[5] + pulses[6] + rx;
						end
						3: begin
							pulses[3] <= rx;
							pcount <= pcountp1;
							Dcnt <= Dcntp1;
							Bcalc <= pulses[0] + pulses[1] + pulses[2] + pulses[4] + pulses[5] + pulses[6] + rx;
						end
						4: begin
							pulses[4] <= rx;
							pcount <= pcountp1;
							Dcnt <= Dcntp1;
							Bcalc <= pulses[0] + pulses[1] + pulses[2] + pulses[3] + pulses[5] + pulses[6] + rx;
						end
						5: begin
							pulses[5] <= rx;
							pcount <= pcountp1;
							Dcnt <= Dcntp1;
							Bcalc <= pulses[0] + pulses[1] + pulses[2] + pulses[3] + pulses[4] + pulses[6] + rx;
						end
						default: begin
							pulses[6] <= rx;
							pcount <= 0;
							Dcnt <= Dcntp1;
							Bcalc <= pulses[0] + pulses[1] + pulses[2] + pulses[3] + pulses[4] + pulses[5] + rx; 
						end
					endcase
				end
			end
			else
				bclkhez <= bclkh;

			if(~SB)
			begin 
				Bvalid <=0;
				SBe <= 0;
				if ((Bcalc <4))
				begin
					SB <= 1;
					parity <= 0;
					Bcnt <=15;
					if (SBe == 0)
					begin
						Dcnt <=4;
						SBe <= 1;
					end
					overrunreg <= validr;
				end
			end
			else if(Dcnt == 7)
				begin
					Bvalid <=1;
				end
			if (SB & Bvalid)
			begin
				Bvalid <= 0;
				case (Bcnt)
					
					0: begin
						data[0] <= Bcalc > 3;
						parity <= pxor ^ (Bcalc > 3);
						Dcnt <= Dcntp1;
						Bcnt <= Bcntp1;
					end
					
					1: begin
						data[1] <= Bcalc > 3;
						parity <= pxor ^ (Bcalc > 3);
						Dcnt <= Dcntp1;
						Bcnt <= Bcntp1;
					end
					
					2: begin
						data[2] <= Bcalc > 3;
						parity <= pxor ^ (Bcalc > 3);
						Dcnt <= Dcntp1;
						Bcnt <= Bcntp1;
					end
					
					3: begin
						data[3] <= Bcalc > 3;
						parity <= pxor ^ (Bcalc > 3);
						Dcnt <= Dcntp1;
						Bcnt <= Bcntp1;
					end
					
					4: begin
						data[4] <= Bcalc > 3;
						parity <= pxor ^ (Bcalc > 3);
						Dcnt <= Dcntp1;
						Bcnt <= Bcntp1;
					end
					
					5: begin
						data[5] <= Bcalc > 3;
						parity <= pxor ^ (Bcalc > 3);
						Dcnt <= Dcntp1;
						Bcnt <= Bcntp1;
					end
					
					6: begin
						data[6] <= Bcalc > 3;
						parity <= pxor ^ (Bcalc > 3);
						Dcnt <= Dcntp1;
						Bcnt <= Bcntp1;
					end
					
					7: begin
						if(dlr)
						begin
							data[7] <= Bcalc > 3;
							parity <= pxor ^ (Bcalc > 3);
							Dcnt <= Dcntp1;
							Bcnt <= Bcntp1;
						end
						else
						begin
							Dcnt <= Dcntp1;
							data[7] <= 0;
							if(ps)
								begin
									Bcnt <= Bcntp1;
									if (parity == (Bcalc > 3))
										parityreg <= 0;
									else
										parityreg <= 1;
								end
							else
							begin
								SB <= 0;
								parityreg <=0;
								Bcnt <= 15;
								if (Bcalc > 3)
								begin
									framereg <= 0;
									validr <= 1;
								end
								else
								begin
									framereg <= 1;
									validr <= 0;
								end
									
							end
						end
					end
					
					8: begin
						Dcnt <= Dcntp1;
						if(dlr)
						begin
							if(ps)
							begin
								Bcnt <= Bcntp1;
								if (parity == (Bcalc > 3))
									parityreg <= 0;
								else
									parityreg <= 1;
							end
							else
							begin
								parityreg <=0;
								Bcnt <= 15;
								SB <= 0;
								validr <= Bcalc >3;
								framereg <= ~(Bcalc >3);
							end
						end
						else
						begin
							SB <= 0;
							Bcnt <= 15;
							if (Bcalc > 3)
							begin
								framereg <= 0;
								validr <= 1;
							end
							else
							begin
								framereg <= 1;
								validr <= 0;
							end
								
						end
					end
					9: begin
						SB <= 0;
						Bcnt <= 15;
						if (Bcalc > 3)
						begin
							framereg <= 0;
							validr <= 1;
						end
						else
						begin
							framereg <= 1;
							validr <= 0;
						end
							
					end
					default:
					begin
						Bcnt <= 0;
						Dcnt <= Dcntp1;
					end
				endcase
			end
			//else
			//	nothing <= 1;
			if (readenez != readen & readen == 1)
				validr <= 0;
			else
				readenez <= readen;
		end	//else reset
	
	end
	
endmodule
module Tx(clk, rst, write_en, data_in, data_out, busy, baud_rate, parity_switch, data_length);
	input clk, rst, write_en, baud_rate, parity_switch, data_length;
	input [7:0] data_in;
	output data_out;
	output busy;
	reg [7:0] data_in_reg;
	reg data, parity;
	reg [3:0] state;
	reg b_clk_l_r, b_clk_h_r, busyreg, b_clk_h_r_ez, b_clk_l_r_ez, mrst;
	wire [3:0] statep1;
	wire btl, bth;
	wire b_clk_l, b_clk_h;
	
	assign statep1 = state + 1;
	assign data_out = data;
	assign b_clk_l = ~b_clk_l_r;
	assign b_clk_h = ~b_clk_h_r;
	assign busy = busyreg;
	
	b9600tx baudlowtx (.clk(clk), .reset(rst | mrst | baud_rate | btl) , .sig(btl));
	b115200tx baudhtx (.clk(clk), .reset(rst | mrst | ~baud_rate | bth), .sig(bth));
	

	always @(posedge clk)
	begin
		if(rst)
		begin
			data <= 1;
			parity <= 0;
			state <= 4'd0;
			b_clk_l_r <= 1;
			b_clk_h_r <= 1;
			busyreg <=0;
			b_clk_h_r_ez <=1;
			b_clk_l_r_ez <=1;
			mrst <= 1;
		end
		else
		begin
			if(btl)
			begin
				b_clk_l_r <= b_clk_l;
			end
			if(bth)
			begin
				b_clk_h_r <= b_clk_h;
			end
			else
				b_clk_h_r <= b_clk_h_r +0;
			
			if (write_en)
			begin 
				data_in_reg <= data_in;
				data <= 0;
				state <= 2;
				busyreg <=1;
				mrst <= 0;
			end

			
			if (busyreg)
			begin
				
				if(b_clk_l_r & (b_clk_l_r != b_clk_l_r_ez))
				begin
					b_clk_l_r_ez <=b_clk_l_r;
					if(~baud_rate)
					begin
						case(state)
	
							2: begin
								data <= data_in_reg[0];
								parity <= data ^ parity;
								state <= statep1;
							end
							3: begin
								data <= data_in_reg[1];
								parity <= data ^ parity;
								state <= statep1;
							end
							4: begin
								data <= data_in_reg[2];
								parity <= data ^ parity;
								state <= statep1;
							end
							5: begin
								data <= data_in_reg[3];
								parity <= data ^ parity;
								state <= statep1;
							end
							6: begin
								data <= data_in_reg[4];
								parity <= data ^ parity;
								state <= statep1;
							end
							7: begin
								data <= data_in_reg[5];
								parity <= data ^ parity;
								state <= statep1;
							end
							8: begin
								data <= data_in_reg[6];
								parity <= data ^ parity;
								state <= statep1;
							end
							9: begin
								if(data_length)//if the length is 8 bit - we send it
									begin
										data <= data_in_reg[7];
										parity <= data ^ parity;
										state <= statep1;
									end
								else if(parity_switch)//else we send the parity
									begin
										data <= parity;
										state <= statep1;
									end
								else
									begin
										data <= 1; //end bit
										state <= 'd0;
									end
							end
							10: begin
								if(data_length & ~parity_switch)
									begin
										data <= 1; //end bit
										state <= 'd0;
									end
								else if(data_length & parity_switch)
									begin
										data <= parity;
										state <= statep1;
									end
								else 
									begin
										data <= 1;//End bit
										state <= 'd0;
									end
							end
							11: begin
								data <= 1; //end bit
								state <= 'd0;
							end
							default: begin
								data <= 1;//End bit
								state <= 'd0;
								busyreg <= 0;
								mrst <= 1;
								b_clk_h_r <= 1;
								b_clk_h_r_ez <=0;
							end
						endcase
					end
				end
				else if(b_clk_h_r & (b_clk_h_r != b_clk_h_r_ez))
				begin
					b_clk_h_r_ez <= b_clk_h_r;
					if (baud_rate)
					begin
						case(state)
	
							2: begin
								data <= data_in_reg[0];
								parity <= data ^ parity;
								state <= statep1;
							end
							3: begin
								data <= data_in_reg[1];
								parity <= data ^ parity;
								state <= statep1;
							end
							4: begin
								data <= data_in_reg[2];
								parity <= data ^ parity;
								state <= statep1;
							end
							5: begin
								data <= data_in_reg[3];
								parity <= data ^ parity;
								state <= statep1;
							end
							6: begin
								data <= data_in_reg[4];
								parity <= data ^ parity;
								state <= statep1;
							end
							7: begin
								data <= data_in_reg[5];
								parity <= data ^ parity;
								state <= statep1;
							end
							8: begin
								data <= data_in_reg[6];
								parity <= data ^ parity;
								state <= statep1;
							end
							9: begin
								if(data_length)//if the length is 8 bit - we send it
									begin
										data <= data_in_reg[7];
										parity <= data ^ parity;
										state <= statep1;
									end
								else if(parity_switch)//else we send the parity
									begin
										data <= parity;
										state <= statep1;
									end
								else
									begin
										data <= 1; //end bit
										state <= 'd0;
									end
							end
							10: begin
								if(data_length & ~parity_switch)
									begin
										data <= 1; //end bit
										state <= 'd0;
									end
								else if(data_length & parity_switch)
									begin
										data <= parity;
										state <= statep1;
									end
								else 
									begin
										data <= 1;//End bit
										state <= 'd0;
									end
							end
							11: begin
								data <= 1; //end bit
								state <= 'd0;
							end
							default: begin
								data <= 1;//End bit
								state <= 'd0;
								busyreg <= 0;
								mrst <= 1;
								b_clk_l_r <= 1;
								b_clk_l_r_ez <=0;
							end
						endcase
					end
				end
				else
				begin
					b_clk_l_r_ez <=b_clk_l_r;
					b_clk_h_r_ez <=b_clk_h_r;
				end
			end
		end
			
	end
endmodule
module LCDc(LCD, LCDe, busy, clk, reset, lettero, LSDew);
	
	`define state0 6'b000000
	`define	state1	6'b000001
	`define	state2	6'd2
	`define	state3	6'd3
	`define	state4	6'd4
	`define	state5	6'd5
	`define	state6	6'd6
	`define	state7	6'd7
	`define	state8	6'd8
	`define	state9	6'd9
	`define	state10	6'd10
	`define	state11	6'd11
	`define	state12	6'd12
	`define	state13	6'd13
	`define	state14	6'd14
	`define	state15	6'd15
	`define state16 6'd16
	`define state17 6'd17
	`define state18 6'd18
	`define state19 6'd19
	`define state20 6'd20
	`define state21 6'd21


	input [7:0] LCD;
	input LCDe, clk, reset;
	output busy, LSDew;
	output [9:0] lettero;
	
	reg [9:0] LSD;
	reg [7:0] LSDez;
	reg [4:0] clkcn;
	reg [4:0] tavcn;
	wire [4:0] clkcnp1;
	reg [4:0]state;
	reg busyr;
	wire [4:0]tavcnp1;
	
	reg en40m,en2m,en50u,LSDe,cnf;
	wire cflag40m,cflag2m,cflag50u;

	assign clkcnp1 = clkcn +1;
	assign lettero = LSD;
	assign LSDew = LSDe;
	assign busy = busyr;
	assign tavcnp1 = tavcn +1;
	
	
	counter40ms time40ms (.clk(clk), .reset(reset | ~en40m),.en(en40m), .out(cflag40m));
	counter2ms time2ms (.clk(clk), .rst(reset | ~en2m),.ena(en2m), .out(cflag2m));
	timer50u time50us (.clk(clk), .reset(reset | ~en50u),.enable(en50u), .out1(cflag50u));
	
	
	always @(reset)
	begin
		
	end
	
	always @(posedge clk)
	begin
		if (reset)
		begin
			state <=0;
			state <=1;
			busyr <= 0;
			en2m <= 0;
			en40m <= 0;
			en50u <= 0;
			clkcn <= 0;
			LSDe <= 0;
			cnf <=1;
			tavcn <= 0;
			LSDez <= 0;
		end
		else
		begin
			case (state)
			
			`state1: begin
				busyr <=1;
				en40m <= 1;
				
				if (cflag40m)
				begin
					state <= `state2;
					cnf <= 0;
				end
				else if (~cnf & cflag40m)
					state <= `state2;
				else
					state <= `state1;
			end
			`state2: begin
				en40m <=0;
				LSD <= 10'b0000110000; // starting initialization
				state <= `state3;
				cnf <= 1;
			end
			`state3:begin
				en50u <= 1;
				if (cnf)
					clkcn <= clkcnp1;
				else
					clkcn <= clkcn;
				if (~|(clkcn ^ 4'd3))
					LSDe <= 1;
				else if (~|(clkcn ^ 4'd15)) begin
					LSDe <= 0;
					cnf <=0;
					end
				else
					LSDe <= LSDe;
					
				if (cflag50u)
				begin
					state <= `state4;
					clkcn <= 0;
				end
				else if (~cnf & cflag50u)
					state <= `state4;
				else
					state <= `state3; // probably problem here
			end
			`state4: begin
				en50u <=0;
				LSD <= 10'b0000110000; // starting initialization
				state <= `state5;
				cnf <= 1;
			end
			`state5:begin
				en50u <= 1;
				if (cnf)
					clkcn <= clkcnp1;
				else
					clkcn <= clkcn;
				if (~|(clkcn ^ 4'd3))
					LSDe <= 1;
				else if (~|(clkcn ^ 4'd15)) begin
					LSDe <= 0;
					cnf <=0;
					end
				else
					LSDe <= LSDe;
					
				if (cflag50u)
				begin
					state <= `state6;
					clkcn <= 0;
				end
				else if (~cnf & cflag50u)
					state <= `state6;
				else
					state <= `state5;
			end
			`state6: begin
				en50u <=0;
				LSD <= 10'b000001111;
				state <= `state7;
				cnf <= 1;
			end
			`state7: begin
				en50u <= 1;
				if (cnf)
					clkcn <= clkcnp1;
				else
					clkcn <= clkcn;
				if (~|(clkcn ^ 4'd3))
					LSDe <= 1;
				else if (~|(clkcn ^ 4'd15)) begin
					LSDe <= 0;
					cnf <=0;
					end
				else
					LSDe <= LSDe;
					
				if (cflag50u)
				begin
					state <= `state8;
					clkcn <= 0;
				end
				else if (~cnf & cflag50u)
					state <= `state8;
				else
					state <= `state7;
			end
			`state8: begin
				en50u <=0;
				LSD <= 10'b1; // clear
				state <= `state9;
				cnf <= 1;
			end
			`state9: begin
				en2m <= 1;
				if (cnf)
					clkcn <= clkcnp1;
				else
					clkcn <= clkcn;
				if (~|(clkcn ^ 4'd3))
					LSDe <= 1;
				else if (~|(clkcn ^ 4'd15)) begin
					LSDe <= 0;
					cnf <=0;
					end
				else
					LSDe <= LSDe;
					
				if (cflag2m)
				begin
					state <= `state10;
					state <= `state10;
					clkcn <= 0;
				end
				else if (~cnf & cflag2m)
					state <= `state10;
				else
					state <= `state9;
			end
			`state10: begin
				en2m <=0;
				LSD <= 10'b0000000110;
				state <= `state11;
				cnf <= 1;
			end
			`state11: begin
				en50u <= 1;
				if (cnf)
					clkcn <= clkcnp1;
				else
					clkcn <= clkcn;
				if (~|(clkcn ^ 4'd3))
					LSDe <= 1;
				else if (~|(clkcn ^ 4'd15)) begin
					LSDe <= 0;
					cnf <=0;
					end
				else
					LSDe <= LSDe;
					
				if (cflag50u)
				begin
					state <= `state12;
					clkcn <= 0;
				end
				else if (~cnf & cflag50u)
					state <= `state12;
				else
					state <= `state11;
			end
			`state12: begin
				en50u <=0;
				en2m <=0;
				LSD <= 10'b0000001111; // display on
				state <= `state13;
				cnf <= 1;
			end
			`state13: begin
				en50u <= 1;
				if (cnf)
					clkcn <= clkcnp1;
				else
					clkcn <= clkcn;
				if (~|(clkcn ^ 4'd3))
					LSDe <= 1;
				else if (~|(clkcn ^ 4'd15)) begin
					LSDe <= 0;
					cnf <=0;
					end
				else
					LSDe <= LSDe;
					
				if (cflag50u)
				begin
					state <= `state14;
					clkcn <= 0;
				end
				else if (~cnf & cflag50u)
					state <= `state14;
				else
					state <= `state13;
			end
			`state14: begin
				en50u <=0;
				en2m <=0;
				LSD <= 10'b0000000110; // entry mode set
				state <= `state15;
				cnf <= 1;
			end
			`state15: begin
				en50u <= 1;
				if (cnf)
					clkcn <= clkcnp1;
				else
					clkcn <= clkcn;
				if (~|(clkcn ^ 4'd3))
					LSDe <= 1;
				else if (~|(clkcn ^ 4'd15)) begin
					LSDe <= 0;
					cnf <=0;
					end
				else
					LSDe <= LSDe;
					
				if (cflag50u)
				begin
					state <= `state16;
					clkcn <= 0;
				end
				else if (~cnf & cflag50u)
					state <= `state16;
				else
					state <= `state15;
			end
			`state16: begin
				en50u <=0;
				en2m <=0;
				busyr <= 0;
				cnf <=1;
				LSD[7:0] <= LCD;
				LSDez[7:0] <= LCD;
				LSD[8] <= 0;
				LSD[9] <= 1;
				if (LCDe)
					if(LCD == 'hd)
						state <= `state18;
					else if(tavcn <16)
					begin
						state <= `state17;
						tavcn <= tavcnp1;
					end
					else
						state <= `state20;
				else
					state <= `state16;
				end
			`state17: begin
				en50u <= 1;
				busyr <= 1;
				if (cnf)
					clkcn <= clkcnp1;
				else
					clkcn <= clkcn;
				if (~|(clkcn ^ 4'd3))
					LSDe <= 1;
				else if (~|(clkcn ^ 4'd15)) begin
					LSDe <= 0;
					cnf <=0;
					end
				else
					LSDe <= LSDe;
					
				if (cflag50u)
				begin
					state <= `state16;
					clkcn <= 0;
				end
				else if (~cnf & cflag50u)
					state <= `state16;
				else
					state <= `state17;
				end
			`state18: begin
				en50u <=0;
				busyr <=1;
				tavcn <= 0;
				en2m <=0;
				LSD <= 10'b1; // clear
				state <= `state19;
				cnf <= 1;
			end
			`state19: begin
				en2m <= 1;
				if (cnf)
					clkcn <= clkcnp1;
				else
					clkcn <= clkcn;
				if (~|(clkcn ^ 4'd3))
					LSDe <= 1;
				else if (~|(clkcn ^ 4'd15)) begin
					LSDe <= 0;
					cnf <=0;
					end
				else
					LSDe <= LSDe;
					
				if (cflag2m)
				begin
					state <= `state16;
					clkcn <= 0;
				end
				else if (~cnf & cflag2m)
					state <= `state16;
				else
					state <= `state19;
			end
			`state20: begin
				en50u <= 1;
				busyr <= 1;
				LSD <= 'h18;
				if (cnf)
					clkcn <= clkcnp1;
				else
					clkcn <= clkcn;
				if (~|(clkcn ^ 4'd3))
					LSDe <= 1;
				else if (~|(clkcn ^ 4'd15)) begin
					LSDe <= 0;
					cnf <=0;
					end
				else
					LSDe <= LSDe;
					
				if (cflag50u)
				begin
					state <= `state21;
					clkcn <= 0;
				end
				else if (~cnf & cflag50u)
				begin
					state <= `state21;
				end
				else
					state <= `state20;
				
			end
			`state21: begin
				en50u <=0;
				en2m <=0;
				LSD[7:0] <= LSDez; 
				LSD[8] <= 0;
				LSD[9] <= 1;
				state <= `state17;
				cnf <= 1;
			end
			default : 
				state <= `state1;
			endcase
		end
		
	end
		
endmodule
	
	
	
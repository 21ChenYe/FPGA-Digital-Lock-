`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:30:02 04/20/2019 
// Design Name: 
// Module Name:    switch_display 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module switch_display(
	input clk,
	input rst,
	input enter,
	input [8:0] SW, 
	input change,
	input cleardsp,
	output [6:0] seven_out, //the display on the SSD depends on 7 values
	output [3:0] AN, //specifies which digit on the SSD to display on (tells where the character goes)
	output reg [3:0] led,
	output [2:0]R,
   output [2:0]G,
   output [1:0]B,
   output HS,
   output VS,
   output light
    );
	 
	 parameter IDLE = 3'b000, Unlocked = 3'b001, Locked = 3'b010, UnlockedIDLE = 3'b011, Unlocked_change = 3'b100;
	 
	 reg [19:0]passin;
	 wire clk_d1;
	 wire enter_out;
	 reg [2:0]present_state = IDLE;
	 reg [2:0]next_state;
	 reg [1:0]PS = 2'b00;
	 reg [1:0]NS;
	 reg [19:0]password= 20'b0;
	 reg [2:0]select = 3'b000;
	 wire [19:0]dsp;
	 integer choose = 0;
	 reg choose_clear = 1'b0;
	 wire temp_clear;
	 
	 reg [2:0]backdoor_present = 3'b000;
	 reg [2:0]backdoor_next = 3'b000;
	 
	 reg [19:0]big_bin = 20'b0;
	 integer count2 = 0;
	 reg [7:0]halfsectime = 8'b0;
	 reg [7:0]halfsec = 8'b0;
	 reg clearint = 0;
	 
	 
	 
	 clk_divider clock(clk, clear, clk_d1); //clock dividerrrrrr, turns the 100 MHz clock provided by board into something else better
	 clk_divider_slow clkdiv(clk, clear, clk_d0);
	 clk_divider_slow clkdivslow(clk, clear, clk_d2);
	 debouncer D1(clk_d0, clear, enter, enter_out);
	 debouncer D2(clk_d0, clear, rst, clear);
	 debouncer D3(clk_d2, clear, change, change_d);
	 debouncer D4(clk_d0, clear, cleardsp, cleardsp_d);
	 
	 initial begin
		present_state[2:0] = IDLE;
		PS [1:0]= 2'b00;
		password[19:0]= 20'b0;
		select [2:0]= 3'b000;
	 end
	 
	 always @(posedge clear, posedge enter_out) begin
			if (clear) begin
				present_state <= IDLE;
				PS <= 2'b00;
				choose_clear <= 1'b1;
				backdoor_present <= 3'b000;
			end else begin
				present_state <= next_state;
				PS <= NS;
				choose_clear <= 1'b0;
				backdoor_present <= backdoor_next;
			 end
	 end
	 
	 always @(posedge cleardsp_d, posedge enter_out) begin
		if (cleardsp_d)
			clearint <= 1'b1;
		else
			clearint <= 1'b0;
	 end
	 
	 assign temp_clear = choose_clear;
	 	 
	seven_segment SS1(clk_d1, dsp[19:0], seven_out[6:0], AN[3:0]);
	mux M1(select, {1'b0,SW[3:0]}, big_bin[19:0], dsp[19:0]);
	
	vga_display VGA(
   clk,
   clear,
   dsp[19:0],
   R[2:0],
   G[2:0],
   B[1:0],
   HS,
   VS,
   light
);
	
	// display I love EC 311
	always @(posedge clk_d0) begin
		if (select == 3'b110) begin
			case (count2)
	   		1: begin big_bin = 20'b11111111111111111111; end
				2: begin big_bin = 20'b11111111111111100001; end
				3: begin big_bin = 20'b11111111110000111111; end
				4: begin big_bin = 20'b11111000011111111100; end
				5: begin big_bin = 20'b00001111111110000000; end
				6: begin big_bin = 20'b11111111000000011000; end
				7: begin big_bin = 20'b11100000001100001110; end
				8: begin big_bin = 20'b00000110000111011111; end
				9: begin big_bin = 20'b11000011101111101110; end
				10: begin big_bin = 20'b01110111110111001100; end
				11: begin big_bin = 20'b11111011100110000011; end
				12: begin big_bin = 20'b01110011000001100001; end
				13: begin big_bin = 20'b01100000110001100001; end
				14: begin big_bin = 20'b00011000010000111111; end
				15: begin big_bin = 20'b00001000011111111111; end
				16: begin big_bin = 20'b00001111111111111111; end
				17: begin count2 <= 1; end
			endcase

		halfsectime <= halfsectime + 8'b00000001;
			

			count2 <= count2 + 1;	
			halfsectime <= 8'b00000000;
	
		end else begin
			count2 <= 1;
		end
		end
	
	 always @(present_state,PS,backdoor_present,SW[8:0],passin,change_d,password,enter_out,temp_clear,clearint) begin
			if (temp_clear) begin
				password[19:0] <= 20'b0;
				next_state <= IDLE;
			end else if (clearint) begin
				NS <= 2'b00;
			end
				
			else if (SW[8:5] == 4'b1010) begin
				backdoor_next <= 3'b0;
				select <= 3'b100;
				case (backdoor_present)
					3'b000: begin
						backdoor_next <= 3'b001;

					end
					3'b001: begin
						backdoor_next <= 3'b010;

					end
					3'b010: begin
						backdoor_next <= 3'b011;

					end
					3'b011: begin
						backdoor_next <= 3'b100;

					end
					3'b100: begin
						backdoor_next <= 3'b101;

					end
					3'b101: begin
						backdoor_next <= 3'b110;
						password [19:0] <= 20'b00001000010001100000;
						next_state <= IDLE;
					end
					3'b110: begin
						backdoor_next <= 3'b000;
						select <= 3'b110; // select to display 'I love EC 311'
						led[3:0] <= 4'b1111;	
					end
				endcase
			end
		
		 else begin
		case (present_state)
		IDLE: begin
			next_state <= Locked;
			select <= 3'b100; // display closed
			led[3:0] <= 3'b0001;
			NS <= 2'b00;
		end
		
		Locked: begin
			led[3:0] <= 4'b0010;
			case (PS) 
				 2'b00: begin
					passin[3:0]<= SW[3:0];
					passin[4] <= 0;
					select <= 3'b000;
					NS <= 2'b01;
					next_state <= Locked;
				 end
				 2'b01: begin
					passin[8:5]<= SW[3:0];
					passin[9] <= 0;
					select <= 3'b001;
					NS <= 2'b10;
					next_state <= Locked;
				 end
				 2'b10: begin
					passin[13:10] <= SW[3:0];
					passin[14] <= 0;
					select <= 3'b010;
					NS <= 2'b11;
					next_state <= Locked;
				 end
				 2'b11: begin
					passin[18:15] <= SW[3:0];
					passin[19] <= 0;
					select <= 3'b011;
					NS <= 2'b00;
					if (passin[19:0] == password[19:0]) begin
						next_state <= UnlockedIDLE;
					end
					else begin
						next_state <= Locked;
					end
				 end

			endcase
		end
		UnlockedIDLE: begin
			if (change_d)
				choose = 1;
			
			case (choose)
				1'b1: begin
					next_state <= Unlocked_change;
					select <= 3'b101; // display open
					led[3:0] <= 4'b1100;
					NS <= 2'b00;
				end
				1'b0: begin
					next_state <= Unlocked;
					select <= 3'b101; // display open
					led[3:0] <= 4'b1010;
					NS <= 2'b00;
				end
			
			endcase
		end
		
		Unlocked_change: begin
			choose = 0;
			led[3:0] <= 4'b0100;
			case (PS) 
				 2'b00: begin
					passin[3:0]<= SW[3:0];
					passin[4] <= 0;
					select <= 2'b00;
					NS <= PS + 1'b1;
					next_state <= Unlocked_change;
				 end
				 2'b01: begin
					passin[8:5]<= SW[3:0];
					passin[9] <= 0;
					select <= 2'b01;
					NS <= PS + 1'b1;
					next_state <= Unlocked_change;
				 end
				 2'b10: begin
					passin[13:10] <= SW[3:0];
					passin[14] <= 0;
					select <= 2'b10;
					NS <= PS + 1'b1;
					next_state <= Unlocked_change;
				 end
				 2'b11: begin
					passin[18:15] <= SW[3:0];
					passin[19] <= 0;
					select <= 2'b11;
					NS <= 2'b00;
					password[19:0] <= passin [19:0];
					next_state <= IDLE;
				 end

			endcase
		end
		Unlocked: begin
			led[3:0] <= 4'b1000;
			case (PS) 
				 2'b00: begin
					passin[3:0]<= SW[3:0];
					passin[4] <= 0;
					select <= 2'b00;
					NS <= PS + 1'b1;
					next_state <= Unlocked;
				 end
				 2'b01: begin
					passin[8:5]<= SW[3:0];
					passin[9] <= 0;
					select <= 2'b01;
					NS <= PS + 1'b1;
					next_state <= Unlocked;
				 end
				 2'b10: begin
					passin[13:10] <= SW[3:0];
					passin[14] <= 0;
					select <= 2'b10;
					NS <= PS + 1'b1;
					next_state <= Unlocked;
				 end
				 2'b11: begin
					passin[18:15] <= SW[3:0];
					passin[19] <= 0;
					select <= 2'b11;
					NS <= 2'b00;
					if (passin[19:0] == password[19:0]) begin
						next_state <= IDLE;
					end
					else begin
						next_state <= UnlockedIDLE;
					end
				 end

			endcase
			end
		
		endcase
		end
	 end
	 
endmodule

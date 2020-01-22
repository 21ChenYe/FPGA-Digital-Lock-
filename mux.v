`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:46:22 04/20/2019 
// Design Name: 
// Module Name:    mux 
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
module mux(
	input [2:0]select,
	input [4:0]I,
	input [19:0]big_bin,
	output reg [19:0]F
    );
	 
	 always @(select, I, big_bin[19:0]) begin
		case (select)
			3'b000: F <= {I[4:0],15'b111111111111111};
			3'b001: F <= {5'b10001,I[4:0],10'b1111111111};
			3'b010: F <= {10'b1000110001,I[4:0],5'b11111};
			3'b011: F <= {15'b100011000110001, I[4:0]};
			3'b100: F <= 20'b01100111000010101101;
			3'b101: F <= 20'b00000100000111011110;
			3'b110: F <= big_bin[19:0];
		endcase
	 end


endmodule

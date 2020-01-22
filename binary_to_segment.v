`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:29:30 04/19/2019 
// Design Name: 
// Module Name:    binary_to_segment 
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
// The SSD digit displays rely on 7 lines 
//    _ 
//   |_|
//   |_|
//   Each one of these lines corresponds to these letters: A, B, C, D, E, F, G
//   Top Middle Line: A 
//   Top Left Line: F
//   Top right line: B
//   Middle Line: G 
//   Bottom Left Line: E
//   Bottom Right Line: C
//   Bottom Middle Line: D
//	  Essentially seven letters which creates a 7-bit pattern (for the seven_out output variable) = ABCDEFG
//	  Example: Wanna display 1? use the top right line and the bottom right line, the bit pattern is 1001111 (0 activates the line)	
//   You need the five bit Seven in variable to decode into the seven_out variable
//   Why 5 bits instead of 4? Well, only four is necessary for number values. Four bits can decode into 0-9 and a - f (16 unique outputs)
//   But we need more than 16 outputs, the natural outputs from 4 bits does not include the following characters: P, V, L, n, -
//   we use five bits to include these, and we can make the five bit inputs correspond to whatever we want
//   Example: 11111 corresponds to -, but if I wanted, I could make 10101 correspond to -. It doesn't matter, as long as its uniform and the five bits used is unique and not used before
//	  hell, if we wanted to, we could make 00000 correspond to 8 or A or U or some random crap. 0000 (4 bit) has a standard seven segment conversion to 0, but technically, we can set it to anything we want!
//
//
//////////////////////////////////////////////////////////////////////////////////
module binary_to_segment(
input [4:0] seven_in,
output reg[6:0] seven_out
    );
always @(*)
	begin
    case(seven_in)
		5'b00000 : seven_out <= 7'b0000001; // "0"     
		5'b00001 : seven_out <= 7'b1001111; // "1" 
		5'b00010 : seven_out <= 7'b0010010; // "2" 
		5'b00011 : seven_out <= 7'b0000110; // "3" 
		5'b00100 : seven_out <= 7'b1001100; // "4" 
		5'b00101 : seven_out <= 7'b0100100; // "5" 
		5'b00110 : seven_out <= 7'b0100000; // "6" 
		5'b00111 : seven_out <= 7'b0001111; // "7" 
		5'b01000 : seven_out <= 7'b0000000; // "8"     
		5'b01001 : seven_out <= 7'b0000100; // "9" 
		5'b01010 : seven_out <= 7'b0000010; // a
		5'b01011 : seven_out <= 7'b1100000; // b
		5'b01100 : seven_out <= 7'b0110001; // C
		5'b01101 : seven_out <= 7'b1000010; // d
		5'b01110 : seven_out <= 7'b0110000; // E
		5'b01111 : seven_out <= 7'b0111000; // F
		5'b10000 : seven_out <= 7'b0011000; // P
		5'b11000 : seven_out <= 7'b1000001; // V
		5'b11100 : seven_out <= 7'b1110001; // L
		5'b11110 : seven_out <= 7'b1101010; // n
		5'b11111 : seven_out <= 7'b1111111; // " "
		5'b10001 : seven_out <= 7'b1111110; // -
		
   endcase
end

endmodule

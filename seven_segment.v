`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// BIG BIN CODE GUIDE: //20 bits, 00000 00000 00000 00000  
// first four of each segment (_0000) are the actual binary shit we care about converting to HEX, the fifth bit (0_ _ _ _) is for seven_in (look in comments of binary_to_segment.v)
// [Display CLSd] 01100 11100 00101 01101
// [Display OPEn] 00000 10000 01110 11110
// [Display all -] 11111 11111 11111 11111
// [Display all 0] 00000 00000 00000 00000
// [Display 2019] 00010 00000 00001 01001
// [Display ---7] 11111 11111 11111 00111
//////////////////////////////////////////////////////////////////////////////////

module seven_segment(
    input clk,
	 input [19:0] big_bin, 
	 output [6:0] seven_out, //the display on the SSD depends on 7 values
	 output reg [3:0] AN //specifies which digit on the SSD to display on (tells where the character goes)
    );
	

	reg [4:0] seven_in; //4 bits allow us to get 0-9 and A-F characters (16 total), but we still need these characters: L, V, -, P, maybe something else i dont remember
	integer count; //increment in order to iterate through different cases
	initial begin // Initial block , used for correct simulations *PROVIDED BY TEACHERS, MIGHT NEED TO CHANGE?*
		AN = 4'b1110; 
		seven_in = 0;
		count = 0;
	end



always @(posedge clk) begin 
	
	count <= count + 1; //count is used to iterate through 0-3 cases (4 total cases), each case being a different digit as specified by AN 
	case (count)
	 0: begin 
		seven_in <= big_bin[4:0]; //bin includes 4 segments of 5 bits each, 
		AN <= 4'b1110; //strangely enough, 0 is used to say ON and 1 is OFF; this is used to specify which digit on the SSD to print to (in this case, the rightmost digit)
			
	 end
	 
	 1: begin 
		seven_in <= big_bin[9:5];
		AN <= 4'b1101;
			
	end
	2: begin 
		seven_in <= big_bin[14:10];
		AN <= 4'b1011;
				
	end
	
	3: begin 
		seven_in <= big_bin[19:15];
		AN <= 4'b0111; 
		count <= 0; //reset count back to zero so it can iterate again
	end
	
	endcase
	
end

binary_to_segment disp0(seven_in,seven_out); //changes Seven Out, which is the character displayed 



endmodule

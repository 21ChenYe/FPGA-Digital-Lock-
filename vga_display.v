`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:49:48 04/21/2019 
// Design Name: 
// Module Name:    vga_display 
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
module vga_display(
	
  input clk,
  input rst,
  input [19:0] big_bin,
  output [2:0]R,
  output [2:0]G,
  output [1:0]B,
  output HS,
  output VS,
  output reg light
);
  
  wire [6:0] digit1;
  wire [6:0] digit2;
  wire [6:0] digit3;
  wire [6:0] digit4;
  wire A[6:0];
  wire E[6:0];
  wire C[6:0];
  wire D[6:0];
  wire [10:0] hcount, vcount;
  wire blank;
  wire clk_25Mhz;
  
 
  binary_to_segment B1(big_bin[4:0], digit1[6:0]);
  binary_to_segment B2(big_bin[9:5], digit2[6:0]);
  binary_to_segment B3(big_bin[14:10], digit3[6:0]);
  binary_to_segment B4(big_bin[19:15], digit4[6:0]);
  
  assign A[0] = {(hcount > 40) & (hcount < 120) * (vcount > 120) & (vcount < 140) ? 1'b1:1'b0}*~digit4[6]; 
  assign A[1] = {(hcount > 120) & (hcount < 140) * (vcount > 140) & (vcount < 240) ? 1'b1:1'b0}*~digit4[5];  
  assign A[2] = {(hcount > 120) & (hcount < 140) * (vcount > 260) & (vcount < 360) ? 1'b1:1'b0}*~digit4[4];
  assign A[3] = {(hcount > 40) & (hcount < 120) * (vcount > 360) & (vcount < 380) ? 1'b1:1'b0}*~digit4[3]; 
  assign A[4] = {(hcount > 20) & (hcount < 40) * (vcount > 260) & (vcount < 360) ? 1'b1:1'b0}*~digit4[2];
  assign A[5] = {(hcount > 20) & (hcount < 40) * (vcount > 140) & (vcount < 240) ? 1'b1:1'b0}*~digit4[1];
  assign A[6] = {(hcount > 40) & (hcount < 120) * (vcount > 240) & (vcount < 260) ? 1'b1:1'b0}*~digit4[0]; 
  
  assign E[0] = {(hcount > 200) & (hcount < 280) * (vcount > 120) & (vcount < 140) ? 1'b1:1'b0}*~digit3[6]; 
  assign E[1] = {(hcount > 280) & (hcount < 300) * (vcount > 140) & (vcount < 240) ? 1'b1:1'b0}*~digit3[5];  
  assign E[2] = {(hcount > 280) & (hcount < 300) * (vcount > 260) & (vcount < 360) ? 1'b1:1'b0}*~digit3[4];
  assign E[3] = {(hcount > 200) & (hcount < 280) * (vcount > 360) & (vcount < 380) ? 1'b1:1'b0}*~digit3[3]; 
  assign E[4] = {(hcount > 180) & (hcount < 200) * (vcount > 260) & (vcount < 360) ? 1'b1:1'b0}*~digit3[2];
  assign E[5] = {(hcount > 180) & (hcount < 200) * (vcount > 140) & (vcount < 240) ? 1'b1:1'b0}*~digit3[1];
  assign E[6] = {(hcount > 200) & (hcount < 280) * (vcount > 240) & (vcount < 260) ? 1'b1:1'b0}*~digit3[0]; 
  
  assign C[0] = {(hcount > 360) & (hcount < 440) * (vcount > 120) & (vcount < 140) ? 1'b1:1'b0}*~digit2[6]; 
  assign C[1] = {(hcount > 440) & (hcount < 460) * (vcount > 140) & (vcount < 240) ? 1'b1:1'b0}*~digit2[5];  
  assign C[2] = {(hcount > 440) & (hcount < 460) * (vcount > 260) & (vcount < 360) ? 1'b1:1'b0}*~digit2[4];
  assign C[3] = {(hcount > 360) & (hcount < 440) * (vcount > 360) & (vcount < 380) ? 1'b1:1'b0}*~digit2[3]; 
  assign C[4] = {(hcount > 340) & (hcount < 360) * (vcount > 260) & (vcount < 360) ? 1'b1:1'b0}*~digit2[2];
  assign C[5] = {(hcount > 340) & (hcount < 360) * (vcount > 140) & (vcount < 240) ? 1'b1:1'b0}*~digit2[1];
  assign C[6] = {(hcount > 360) & (hcount < 440) * (vcount > 240) & (vcount < 260) ? 1'b1:1'b0}*~digit2[0]; 
  
  assign D[0] = {(hcount > 520) & (hcount < 600) * (vcount > 120) & (vcount < 140) ? 1'b1:1'b0}*~digit1[6]; 
  assign D[1] = {(hcount > 600) & (hcount < 620) * (vcount > 140) & (vcount < 240) ? 1'b1:1'b0}*~digit1[5];  
  assign D[2] = {(hcount > 600) & (hcount < 620) * (vcount > 260) & (vcount < 360) ? 1'b1:1'b0}*~digit1[4];
  assign D[3] = {(hcount > 520) & (hcount < 600) * (vcount > 360) & (vcount < 380) ? 1'b1:1'b0}*~digit1[3]; 
  assign D[4] = {(hcount > 500) & (hcount < 520) * (vcount > 260) & (vcount < 360) ? 1'b1:1'b0}*~digit1[2];
  assign D[5] = {(hcount > 500) & (hcount < 520) * (vcount > 140) & (vcount < 240) ? 1'b1:1'b0}*~digit1[1];
  assign D[6] = {(hcount > 520) & (hcount < 600) * (vcount > 240) & (vcount < 260) ? 1'b1:1'b0}*~digit1[0]; 
  
  clock_divider clk_div_25 (
   .clock_in(clk),
   .reset(rst),
   .clock_out(clk_25Mhz)
  );

  vga_controller_640_60 vc(
    .rst(rst),
	 .pixel_clk(clk_25Mhz),
	 .HS(HS),
	 .VS(VS),
	 .hcounter(hcount),
	 .vcounter(vcount),
	 .blank(blank)
  );
 	

  always @(posedge clk_25Mhz) begin
    light <= ~blank;	  	 
  end
	
	 
  
	  
  
  
  assign background =   { (hcount>0) & (hcount<640) & (vcount>0) & (vcount < 480) ? 1'b1:1'b0};  
  assign square = {(hcount > 200) & (hcount < 440) & (vcount > 120) & (vcount < 360)? 1'b1:1'b0};
 
  //assign G[0] = {{0,0,0}};
  assign G[2:0] = {3{A[6] + A[5] + A[4] + A[3] + A[2] + A[1] + A[0] + E[6] + E[5] + E[4] + E[3] + E[2] + E[1] + E[0] + C[6] + C[5] + C[4] + C[3] + C[2] + C[1] + C[0] + D[6] + D[5] + D[4] + D[3] + D[2] + D[1] + D[0]}};
  assign R[2:0] = {3{background}};
  assign B = {{0,0}};

 
endmodule

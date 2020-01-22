`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:56:41 04/21/2019 
// Design Name: 
// Module Name:    clock_divider 
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
module clock_divider (
  input clock_in,
  input reset,
  output reg clock_out
);

reg [1:0] count;

always@(posedge clock_in or posedge reset) begin
  if(reset) begin
    count <= 2'b00;
  end else begin
    count <= count + 1'b1;
  end
end

always@(posedge clock_in or posedge reset) begin
  if(reset) begin
    clock_out <= 1'b0;
  end else begin
    clock_out <= count[1];
  end
end

endmodule

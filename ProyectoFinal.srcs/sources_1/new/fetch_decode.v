`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2024 06:32:58 PM
// Design Name: 
// Module Name: fetch_decode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fetch_decode (
    clk,
    reset,
    PCPlus4F,
    InstrF,
    PCPlus8D,
    InstrD
);

input wire clk;
input wire reset;
input wire [31:0] PCPlus4F;
input wire [31:0] InstrF;
output reg [31:0] PCPlus8D;
output reg [31:0] InstrD;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        PCPlus8D <= 0;
        InstrD <= 0;
    end else begin
        PCPlus8D <= PCPlus4F;
        InstrD <= InstrF;
    end
end

endmodule
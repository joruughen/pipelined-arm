`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2024 04:35:50 PM
// Design Name: 
// Module Name: fetch_stg
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


module fetch_stg(
    clk,
    reset,
    Flags, 
    ResultW,
    PCF,
    InstrF
    );

input wire clk;
input wire reset;
input wire Flags;    
input wire [31:0] ResultW;
output wire [31:0] PCF;
output wire [31:0] InstrF;
wire [31:0] PCNext;
wire [31:0] PCPlus4F;

mux2 pcmux(
    .d0(ResultW), 
    .d1(PCPlus4F), 
    .s(Flags),
    .y(PCNext)
);

flopr pcflop(
    .clk(clk),
    .reset(reset),
    .d(PCNext),
    .q(PCF)
);

adder addpc(
    .a(PCF),
    .b(32'd4),
    .y(PCPlus4F)
);

imem insmem(
   .a(PCF),
   .rd(InstrF)
);
    
endmodule

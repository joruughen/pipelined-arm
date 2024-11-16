`timescale 1ns / 1ps

module fetch_stg(
    clk,
    reset, 
    PCSrcW,
    ResultW,
    InstrF,
    PCPlus8D
);

input wire clk;
input wire reset;
input wire PCSrcW;
input wire [31:0] ResultW;
output wire [31:0] InstrF;
output wire [31:0] PCPlus8D;

wire [31:0] PCPlus4F;
wire [31:0] PCNext;
wire [31:0] PCF;

mux2 #(32) pcmux (
    .d0(ResultW), 
    .d1(PCPlus4F), 
    .s(PCSrcW),
    .y(PCNext)
);

flopr #(32) pcflop (
    .clk(clk),
    .reset(reset),
    .d(PCNext),
    .q(PCF)
);

adder #(32) addpc (
    .a(PCF),
    .b(32'd4),
    .y(PCPlus4F)
);

imem insmem (
    .a(PCF),
    .rd(InstrF)
);

assign PCPlus8D = PCPlus4F;

endmodule

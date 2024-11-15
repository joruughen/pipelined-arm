`timescale 1ns / 1ps


module fetch_stg(
    input wire clk,
    input wire reset,
    input wire Flags, 
    input wire [31:0] ResultW,
    output wire [31:0] PCF,
    output wire [31:0] InstrF
);

    wire [31:0] PCNext;
    wire [31:0] PCPlus4F;

    mux2 #(32) pcmux (
        .d0(ResultW), 
        .d1(PCPlus4F), 
        .s(Flags),
        .y(PCNext)
    );

    flopr #(32) pcflop (
        .clk(clk),
        .reset(reset),
        .d(PCNext),
        .q(PCF)
    );

    adder addpc (
        .a(PCF),
        .b(32'd4),
        .y(PCPlus4F)
    );

    imem insmem (
        .a(PCF),
        .rd(InstrF)
    );
    
endmodule

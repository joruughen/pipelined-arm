`timescale 1ns / 1ps

module arm (
    input wire clk,
    input wire reset,
    output wire [31:0] PC,
    input wire [31:0] Instr,
    output wire MemWrite,
    output wire [31:0] ALUResult,
    output wire [31:0] WriteData,
    input wire [31:0] ReadData
);

    // Señales internas
    wire [3:0] FlagsE;
    wire RegWrite;
    wire ALUSrc;
    wire MemToReg;
    wire PCSrc;
    wire [1:0] RegSrc;
    wire [1:0] ImmSrc;
    wire [1:0] ALUControl;

    // Instancia del módulo controller
    controller c (
        .clk(clk),
        .reset(reset),
        .InstrD(Instr),
        .FlagsE(FlagsE),
        .PCSrcE(PCSrc),
        .RegWriteD(RegWrite),
        .MemToRegD(MemToReg),
        .MemWriteD(MemWrite),
        .ALUSrcD(ALUSrc),
        .ALUControlD(ALUControl),
        .FlagWriteD(),
        .ImmSrcD(ImmSrc),
        .RegSrcD(RegSrc)
    );

    // Instancia del módulo datapath
    datapath dp (
        .clk(clk),
        .reset(reset),
        .RegSrc(RegSrc),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl),
        .MemToReg(MemToReg),
        .PCSrc(PCSrc),
        .ALUFlags(FlagsE),
        .PC(PC),
        .Instr(Instr),
        .ALUResult(ALUResult),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );

endmodule

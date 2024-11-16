`timescale 1ns / 1ps

module arm (
    input wire clk,
    input wire reset,
    output wire [31:0] PC,
    input wire [31:0] Instr,       // Instrucción desde la memoria
    output wire MemWrite,
    output wire [31:0] ALUResult,
    output wire [31:0] WriteData,
    input wire [31:0] ReadData,
    output wire [31:0] ResultW
);

    // Señales internas
    wire [31:0] InstrF;
    wire [31:0] ReadDataM;
    wire [3:0] FlagsE;
    wire RegWrite;
    wire ALUSrc;
    wire MemToReg;
    wire PCSrc;
    wire [1:0] RegSrc;
    wire [1:0] ImmSrc;
    wire [2:0] ALUControl;
    wire [1:0] FlagWrite;

    // Asignaciones intermedias
    assign InstrF = Instr;     // Conectar entrada Instr a wire InstrF
    assign ReadDataM = ReadData; // Conectar entrada ReadData a wire ReadDataM

    // Instancia del módulo controller
    controller c (
        .clk(clk),
        .reset(reset),
        .InstrD(InstrF),
        .FlagsE(FlagsE),
        .PCSrcE(PCSrc),
        .RegWriteD(RegWrite),
        .MemToRegD(MemToReg),
        .MemWriteD(MemWrite),
        .ALUSrcD(ALUSrc),
        .ALUControlD(ALUControl),
        .FlagWriteD(FlagWrite),
        .ImmSrcD(ImmSrc),
        .RegSrcD(RegSrc)
    );

    // Instancia del módulo datapath
    datapath dp (
        .clk(clk),
        .reset(reset),
        .PCSrcW(PCSrc),
        .PCF(PC),
        .InstrF(InstrF),
        .RegSrcD(RegSrc),
        .RegWriteW(RegWrite),
        .ALUControlE(ALUControl),
        .ALUFlags(FlagsE),
        .ALUResultE(ALUResult),
        .WriteDataM(WriteData),
        .ReadDataM(ReadDataM),
        .MemToRegW(MemToReg),
        .ResultW(ResultW)
    );

endmodule

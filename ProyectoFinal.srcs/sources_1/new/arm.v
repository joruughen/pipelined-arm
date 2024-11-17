`timescale 1ns / 1ps

module arm (
    input wire clk,
    input wire reset,
    output wire [31:0] PC,          // Dirección del PC actual
    input wire [31:0] Instr,        // Instrucción desde la memoria
    output wire MemWrite,           // Señal para escribir en memoria
    output wire [31:0] ALUResult,   // Resultado de la ALU
    output wire [31:0] WriteData,   // Datos que se escribirán en memoria
    input wire [31:0] ReadData,     // Datos leídos desde memoria
    output wire [31:0] ResultW      // Resultado final en Write-back
);

    // Señales internas
    wire [31:0] InstrF;            // Instrucción desde el fetch stage
    wire [31:0] ReadDataM;         // Datos leídos desde memoria (mem stage)
    wire [3:0] FlagsE;             // Flags generados por la ALU
    wire RegWrite;                 // Habilitación de escritura en registros
    wire ALUSrc;                   // Selección de fuente de datos para la ALU
    wire MemToReg;                 // Selección de datos para escritura en WB
    wire PCSrc;                    // Selección de fuente para actualizar el PC
    wire [1:0] RegSrc;             // Control para seleccionar el registro fuente
    wire [1:0] ImmSrc;             // Selección de extensión de inmediato
    wire [2:0] ALUControl;         // Control para la operación de la ALU
    wire [1:0] FlagWrite;          // Habilitación de escritura de flags (NZCV)

    // Conexiones internas
    assign InstrF = Instr;
    assign ReadDataM = ReadData;

    // Instancia del módulo controller
    controller c (
        .clk(clk),
        .reset(reset),
        .InstrD(InstrF),           // Instrucción decodificada
        .FlagsE(FlagsE),           // Flags desde la ALU
        .PCSrcE(PCSrc),            // Señal para salto condicional
        .RegWriteD(RegWrite),      // Habilitación de escritura en registros
        .MemToRegD(MemToReg),      // Selección para Memoria o ALU en WB
        .MemWriteD(MemWrite),      // Señal para escritura en memoria
        .ALUSrcD(ALUSrc),          // Selección de fuente para la ALU
        .ALUControlD(ALUControl),  // Operación de la ALU
        .FlagWriteD(FlagWrite),    // Habilitación de escritura de flags
        .ImmSrcD(ImmSrc),          // Selección de extensión de inmediato
        .RegSrcD(RegSrc)           // Selección de registro fuente
    );

    // Instancia del módulo datapath
    datapath dp (
        .clk(clk),
        .reset(reset),
        .PCSrcW(PCSrc),
        .RegSrcD(RegSrc),
        .ImmSrcD(ImmSrc),
        .ALUSrcE(ALUSrcE),
        .ALUControlE(ALUControl),
        .PCF(PC),
        .InstrF(InstrF),
        .ALUFlags(ALUFlags),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .ReadDataM(ReadData),
        .ResultW(ResultW)
        );

   

endmodule

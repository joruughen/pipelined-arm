`timescale 1ns / 1ps

module controller (
    input wire clk,
    input wire reset,
    input wire [31:0] InstrD,         // Instrucción en etapa Decode
    input wire [3:0] FlagsE,          // Banderas de ALU en Execute
    output wire PCSrcE,               // Señal de salto generada en Execute
    output wire RegWriteD,            // Escritura en registro desde Decode
    output wire MemToRegD,            // Selección de memoria a registro desde Decode
    output wire MemWriteD,            // Escritura en memoria desde Decode
    output wire ALUSrcD,              // Fuente de ALU en Decode
    output wire [2:0] ALUControlD,    // Control de ALU en Decode
    output wire [1:0] FlagWriteD,     // Escritura de banderas en Execute
    output wire [1:0] ImmSrcD,        // Fuente de inmediato en Decode
    output wire [1:0] RegSrcD         // Fuente de registro en Decode
);

    // Señales internas
    wire [1:0] OpD = InstrD[27:26];        // Operación desde la instrucción
    wire [5:0] FunctD = InstrD[25:20];     // Función para determinar ALUControl
    wire [3:0] RdD = InstrD[15:12];        // Registro destino en Decode
    wire [3:0] CondD = InstrD[31:28];      // Condición de salto extraída de la instrucción

    // Señales de control intermedias entre decode y condlogic
    wire FlagWriteCondLogic;
    wire MemWriteCondLogic;
    wire RegWriteCondLogic;

    // Instancia del decodificador (decode)
    decode dec (
        .Op(OpD),
        .Funct(FunctD),
        .Rd(RdD),
        .RegWriteD(RegWriteD),
        .MemToRegD(MemToRegD),
        .MemWriteD(MemWriteD),
        .ALUSrcD(ALUSrcD),
        .FlagWriteD(FlagWriteD),
        .ImmSrcD(ImmSrcD),
        .RegSrcD(RegSrcD),
        .ALUControlD(ALUControlD)
    );

    // Instancia de la Unidad de Condiciones (condlogic)
    condlogic cond_unit (
        .clk(clk),
        .reset(reset),
        .CondE(CondD),                // Condición para la ejecución de salto desde decode
        .FlagsE(FlagsE),              // Banderas de ALU desde Execute
        .FlagWriteE(FlagWriteD),      // Control de escritura de banderas en Execute
        .PCSrcControlE(1'b1),         // Control de salto habilitado (puede ajustarse)
        .RegWriteControlE(RegWriteD),
        .MemWriteControlE(MemWriteD),
        .PCSrcE(PCSrcE),              // Señal de salto calculada
        .RegWriteE(RegWriteCondLogic),
        .MemWriteE(MemWriteCondLogic)
    );

endmodule

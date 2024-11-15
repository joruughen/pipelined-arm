module top (
    input wire clk,
    input wire reset,
    output wire [31:0] WriteData,
    output wire [31:0] DataAdr,
    output wire MemWrite
);

    // Señales internas
    wire [31:0] PC;
    wire [31:0] Instr;
    wire [31:0] ReadData;
    
    // Señales entre las etapas del pipeline y los módulos de memoria

    // Instancia del módulo ARM con pipeline
    arm arm (
        .clk(clk),
        .reset(reset),
        .PC(PC),                     // Contador de programa que avanza en cada ciclo
        .Instr(Instr),               // Instrucción desde la memoria de instrucciones
        .MemWrite(MemWrite),         // Señal de escritura en memoria
        .ALUResult(DataAdr),         // Dirección calculada por la ALU para acceso a memoria
        .WriteData(WriteData),       // Datos a escribir en memoria
        .ReadData(ReadData)          // Datos leídos desde la memoria de datos
    );

    // Instancia de la memoria de instrucciones (Instruction Memory)
    imem imem (
        .a(PC),                      // Dirección desde el contador de programa
        .rd(Instr)                   // Instrucción leída
    );

    // Instancia de la memoria de datos (Data Memory)
    dmem dmem (
        .clk(clk),
        .we(MemWrite),               // Señal de escritura en memoria
        .a(DataAdr),                 // Dirección calculada por la ALU
        .wd(WriteData),              // Datos a escribir en la memoria
        .rd(ReadData)                // Datos leídos desde la memoria
    );

endmodule

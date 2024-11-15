module condlogic (
    input wire clk,
    input wire reset,
    input wire [3:0] CondE,            // Condición de salto en Execute
    input wire [3:0] FlagsE,           // Banderas de ALU en Execute
    input wire [1:0] FlagWriteE,       // Control de escritura de banderas en Execute
    input wire PCSrcControlE,          // Control de salto en Execute
    input wire RegWriteControlE,       // Control de escritura en registro en Execute
    input wire MemWriteControlE,       // Control de escritura en memoria en Execute
    input wire BranchE,                // Señal de salto condicional (branch)
    output wire PCSrcE,                // Señal de salto en Execute
    output wire RegWriteE,             // Señal de escritura en registro en Execute
    output wire MemWriteE              // Señal de escritura en memoria en Execute
);

    wire [1:0] FlagWrite;              // Control de escritura de banderas
    wire [3:0] Flags;                  // Banderas almacenadas
    wire CondExE;                      // Resultado de la evaluación de condición

    // Registros para almacenar banderas
    flopenr #(2) flagreg1 (
        .clk(clk),
        .reset(reset),
        .en(FlagWrite[1]),
        .d(FlagsE[3:2]),
        .q(Flags[3:2])
    );

    flopenr #(2) flagreg0 (
        .clk(clk),
        .reset(reset),
        .en(FlagWrite[0]),
        .d(FlagsE[1:0]),
        .q(Flags[1:0])
    );

    // Módulo condcheck para evaluar si la condición se cumple
    condcheck cc (
        .Cond(CondE),
        .Flags(Flags),
        .CondEx(CondExE)
    );

    // Lógica condicional de control en la etapa Execute
    assign FlagWrite = FlagWriteE & {2{CondExE}};
    assign RegWriteE = RegWriteControlE & CondExE;
    assign MemWriteE = MemWriteControlE & CondExE;
    
    // Lógica de salto condicional
    assign PCSrcE = (PCSrcControlE & CondExE) | (BranchE & CondExE);

endmodule


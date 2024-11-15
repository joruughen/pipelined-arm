`timescale 1ns / 1ps

module execute_memory (
    input wire clk,
    input wire reset,
    input wire [31:0] ALUResultE,   // Resultado de la ALU en Execute
    input wire [31:0] WriteDataE,   // Datos a escribir en memoria en Execute
    input wire [3:0] WA3E,          // Dirección del registro destino en Execute
    input wire PCSrcE,              // Señal de salto en Execute
    input wire RegWriteE,           // Control de escritura en registro en Execute
    input wire MemToRegE,           // Control de selección de memoria a registro en Execute
    input wire MemWriteE,           // Control de escritura en memoria en Execute
    output reg [31:0] ALUOutM,      // Resultado de la ALU propagado a Memory
    output reg [31:0] WriteDataM,   // Datos a escribir en memoria propagado a Memory
    output reg [3:0] WA3M,          // Dirección del registro destino propagado a Memory
    output reg PCSrcM,              // Señal de salto propagada a Memory
    output reg RegWriteM,           // Control de escritura en registro propagado a Memory
    output reg MemToRegM,           // Control de selección de memoria a registro en Memory
    output reg MemWriteM            // Control de escritura en memoria en Memory
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reinicia todas las salidas en caso de reset
        ALUOutM <= 32'b0;
        WriteDataM <= 32'b0;
        WA3M <= 4'b0;
        PCSrcM <= 1'b0;
        RegWriteM <= 1'b0;
        MemToRegM <= 1'b0;
        MemWriteM <= 1'b0;
    end else begin
        // Propaga las señales desde Execute a Memory en cada ciclo
        ALUOutM <= ALUResultE;
        WriteDataM <= WriteDataE;
        WA3M <= WA3E;
        PCSrcM <= PCSrcE;
        RegWriteM <= RegWriteE;
        MemToRegM <= MemToRegE;
        MemWriteM <= MemWriteE;
    end
end

endmodule
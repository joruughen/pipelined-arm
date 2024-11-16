`timescale 1ns / 1ps

module decode (
    Op, 
    Funct, 
    Rd, 
    PCSrcD, 
    RegWriteD, 
    MemToRegD,
    MemWriteD,
    ALUControlD, 
    BranchD, 
    ALUSrcD, 
    FlagWriteD, 
    ImmSrcD, 
    RegSrcD
);

input wire [1:0] Op;
input wire [5:0] Funct;
input wire [3:0] Rd;
output reg [1:0] FlagWriteD;      // Señal de escritura de flags
output wire PCSrcD;                // Selección de PC (para salto o no)
output wire RegWriteD;             // Escritura en registro
output wire MemWriteD;             // Escritura en memoria
output wire MemToRegD;             // Selección de memoria a registro
output wire ALUSrcD;               // Fuente de ALU (inmediato o registro)
output wire [1:0] ImmSrcD;         // Fuente del inmediato
output wire [1:0] RegSrcD;         // Fuente del registro
output wire BranchD;               // Señal de branch
output reg [2:0] ALUControlD;      // Control de ALU

// Señales internas
reg [9:0] controls;                // Señales de control agrupadas
wire ALUOp;                        // Señal de operación de ALU

// Lógica de control principal
always @(*) begin
    case (Op)
        2'b00: begin
            if (Funct[5])
                controls = 10'b0000101001; // Ejemplo de control tipo R
            else
                controls = 10'b0000001001; // Otro ejemplo de tipo R
        end
        2'b01: begin
            if (Funct[0])
                controls = 10'b0001111000; // Ejemplo de tipo I o LD/ST
            else
                controls = 10'b1001110100; // Ejemplo de branch
        end
        2'b10: controls = 10'b0110100010; // Otro caso específico
        default: controls = 10'bxxxxxxxxxx; // Caso por defecto
    endcase
end

// Asignación de señales de control a salidas
assign {RegSrcD, ImmSrcD, ALUSrcD, MemToRegD, RegWriteD, MemWriteD, BranchD, ALUOp} = controls;

// Lógica de control de ALU y escritura de flags
always @(*) begin
    if (ALUOp) begin
        case (Funct[4:1])
            4'b0100: ALUControlD = 2'b00;   // Operación ADD
            4'b0010: ALUControlD = 2'b01;   // Operación SUB
            4'b0000: ALUControlD = 2'b10;   // Operación AND
            4'b1100: ALUControlD = 2'b11;   // Operación OR
            default: ALUControlD = 2'bxx;   // Caso desconocido
        endcase
        FlagWriteD[1] = Funct[0];
        FlagWriteD[0] = Funct[0] & ((ALUControlD == 2'b00) | (ALUControlD == 2'b01));
    end else begin
        ALUControlD = 2'b00;
        FlagWriteD = 2'b00;
    end
end

// Control de salto (PCSrcD)
assign PCSrcD = ((Rd == 4'b1111) & RegWriteD) | BranchD;

endmodule
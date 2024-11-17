`timescale 1ns / 1ps

module datapath_tb;

    // Inputs
    reg clk;
    reg reset;
    reg PCSrcW;
    reg [1:0] RegSrcD;
    reg [1:0] ImmSrcD;
    reg ALUSrcE;
    reg [2:0] ALUControlE;

    // Outputs
    wire [31:0] PCF;
    wire [31:0] InstrF;
    wire [3:0] ALUFlags;
    wire [31:0] ALUResultE;
    wire [31:0] WriteDataE;
    wire [31:0] ReadDataM;
    wire [31:0] ResultW;

    // Instancia del datapath
    datapath dp (
        .clk(clk),
        .reset(reset),
        .PCSrcW(PCSrcW),
        .RegSrcD(RegSrcD),
        .ImmSrcD(ImmSrcD),
        .ALUSrcE(ALUSrcE),
        .ALUControlE(ALUControlE),
        .PCF(PCF),
        .InstrF(InstrF),
        .ALUFlags(ALUFlags),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .ReadDataM(ReadDataM),
        .ResultW(ResultW)
    );

    // Generación de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Periodo de reloj de 10ns
    end

    // Secuencia de prueba
    initial begin
        reset = 1;
        // Inicialización

end
endmodule



/*
module datapath_tb;
    reg clk;
    reg reset;
    reg [1:0] RegSrcD;
    reg [31:0] ReadDataM;
    reg MemToRegW;
    wire [31:0] ResultW;

    datapath uut (
        .clk(clk),
        .reset(reset),
        .RegSrcD(RegSrcD),
        .ReadDataM(ReadDataM),
        .MemToRegW(MemToRegW),
        .ResultW(ResultW)
    );

    initial begin
        // Inicializar señales
        clk = 0;
        reset = 1;
        RegSrcD = 2'b00;
        ReadDataM = 32'hA5A5A5A5;
        MemToRegW = 0;

        // Aplicar estímulos
        #5 reset = 0;
        #10 RegSrcD = 2'b01;
        #10 MemToRegW = 1;
        #20 ReadDataM = 32'hFFFF0000;

        // Terminar simulación
        #50 $finish;
    end

    always #5 clk = ~clk; // Generar reloj
endmodule


`timescale 1ns / 1ps

module datapath_tb;

    // Declaración de señales
    reg clk;
    reg reset;
    reg PCSrcW;                 // Cambiado a reg
    wire [31:0] PCF;            // Salida del datapath
    reg [31:0] InstrF;          // Cambiado a reg
    reg [1:0] RegSrcD;          // Cambiado a reg
    reg RegWriteW;              // Cambiado a reg
    reg [2:0] ALUControlE;      // Cambiado a reg
    wire [3:0] ALUFlags;        // Salida del datapath
    wire [31:0] ALUResultE;     // Salida del datapath
    wire [31:0] WriteDataM;     // Salida del datapath
    reg [31:0] ReadDataM;       // Cambiado a reg
    reg MemToRegW;              // Cambiado a reg
    wire [31:0] ResultW;        // Salida del datapath

    // Instancia del módulo datapath
    datapath uut (
        .clk(clk),
        .reset(reset),
        .PCSrcW(PCSrcW),
        .PCF(PCF),
        .InstrF(InstrF),
        .RegSrcD(RegSrcD),
        .RegWriteW(RegWriteW),
        .ALUControlE(ALUControlE),
        .ALUFlags(ALUFlags),
        .ALUResultE(ALUResultE),
        .WriteDataM(WriteDataM),
        .ReadDataM(ReadDataM),
        .MemToRegW(MemToRegW),
        .ResultW(ResultW)
    );

    // Generación de reloj
    always #5 clk = ~clk; // Período de 10ns

    // Procedimiento inicial
    initial begin
        // Inicialización de señales
        clk = 0;
        reset = 1;
        PCSrcW = 0;
        InstrF = 32'hE3A02003;  // MOV R2, #3 (ejemplo)
        RegSrcD = 2'b00;
        RegWriteW = 0;
        ALUControlE = 3'b010;  // ADD
        ReadDataM = 32'h00000000;
        MemToRegW = 0;

        // Reset del datapath
        #10;
        reset = 0;

        // Simulación de algunas instrucciones
        #10;
        PCSrcW = 1;
        InstrF = 32'hE3A03004;  // MOV R3, #4 (otro ejemplo)

        #10;
        RegWriteW = 1;
        MemToRegW = 1;

        #10;
        InstrF = 32'hE2822001;  // ADD R2, R2, #1

        #10;
        RegWriteW = 0;

        #10;
        PCSrcW = 0;
        InstrF = 32'hE3A01001;  // MOV R1, #1

        // Finalizar simulación
        #50;
        $stop;
    end

endmodule
*/

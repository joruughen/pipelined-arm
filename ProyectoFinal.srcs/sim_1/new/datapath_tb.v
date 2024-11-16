`timescale 1ns / 1ps

module datapath_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [1:0] RegSrcD;
    reg [31:0] ReadDataM;
    reg MemToRegW;
    reg [31:0] InstrF;
    reg [2:0] ALUControlE;
    reg PCSrcW;
    reg RegWriteW;

    // Outputs
    wire [31:0] PCF;
    wire [31:0] ResultW;
    wire [31:0] WriteDataM;
    wire [3:0] ALUFlags;
    wire [31:0] ALUResultE;

    // Instancia del datapath
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

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;
        RegSrcD = 2'b00;
        ReadDataM = 32'h00000000;
        MemToRegW = 0;
        InstrF = 32'hE3A01001; // MOV R1, #1
        ALUControlE = 3'b010;  // ADD operation
        PCSrcW = 0;
        RegWriteW = 1;

        // Wait for reset deassertion
        #10 reset = 0;

        // Test 1: MOV instruction
        #10 InstrF = 32'hE3A02002; // MOV R2, #2
        RegSrcD = 2'b01;
        ALUControlE = 3'b000; // MOV operation

        // Test 2: ADD operation
        #20 InstrF = 32'hE0803002; // ADD R3, R0, R2
        RegSrcD = 2'b10;
        ALUControlE = 3'b010; // ADD

        // Test 3: Memory Write
        #30 InstrF = 32'hE5812000; // STR R2, [R1]
        ReadDataM = 32'h12345678;
        MemToRegW = 1;

        // Test 4: Branch (unconditional)
        #40 InstrF = 32'hEA000003; // B +3
        PCSrcW = 1;

        // Finish simulation
        #50 $finish;
    end

    // Monitor values
    initial begin
        $monitor("Time: %0dns | PCF: %h | InstrF: %h | ResultW: %h | WriteDataM: %h | ALUResultE: %h",
                 $time, PCF, InstrF, ResultW, WriteDataM, ALUResultE);
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

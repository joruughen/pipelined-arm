module datapath (
    input wire clk,
    input wire reset,
    input wire [1:0] RegSrc,       // Fuente de registro
    input wire RegWrite,           // Señal de escritura de registro
    input wire [1:0] ImmSrc,       // Fuente de inmediato
    input wire ALUSrc,             // Fuente de ALU
    input wire [1:0] ALUControl,   // Control de ALU
    input wire MemToReg,           // Selección de memoria a registro
    input wire PCSrc,              // Señal de salto
    output wire [3:0] ALUFlags,    // Banderas de ALU
    output wire [31:0] PC,         // Contador de programa
    input wire [31:0] Instr,       // Instrucción
    output wire [31:0] ALUResult,  // Resultado de ALU
    output wire [31:0] WriteData,  // Datos a escribir
    input wire [31:0] ReadData     // Datos leídos
);

    // Fetch Stage Signals
    wire [31:0] PCNext;
    wire [31:0] PCPlus4F;
    wire [31:0] InstrF;

    // Decode Stage Signals
    wire [31:0] PCPlus8D;
    wire [31:0] InstrD;
    wire [31:0] ExtImmD;
    wire [31:0] RD1D;
    wire [31:0] RD2D;
    wire [3:0] WA3D;
    wire RegWriteD;
    wire MemToRegD;
    wire MemWriteD;

    // Execute Stage Signals
    wire [31:0] PCPlus8E;
    wire [31:0] ExtImmE;
    wire [31:0] RD1E;
    wire [31:0] RD2E;
    wire [3:0] WA3E;
    wire RegWriteE;
    wire MemToRegE;
    wire MemWriteE;
    wire [31:0] ALUResultE;
    wire [31:0] WriteDataE;

    // Memory Stage Signals
    wire [31:0] ALUOutM;
    wire [31:0] WriteDataM;
    wire [3:0] WA3M;
    wire RegWriteM;
    wire MemToRegM;
    wire MemWriteM;

    // Write Back Stage Signals
    wire [31:0] ALUOutW;
    wire [31:0] ReadDataW;
    wire [3:0] WA3W;
    wire RegWriteW;
    wire MemToRegW;

    // Fetch Stage
    fetch_stg fetch_stage (
        .clk(clk),
        .reset(reset),
        .Flags(1'b0),
        .ResultW(ALUOutW),  // Assuming ALUOutW is used for PC update; adjust as needed
        .PCF(PC),
        .InstrF(InstrF)
    );

    // IF/ID Pipeline Register
    fetch_decode if_id (
        .clk(clk),
        .reset(reset),
        .PCPlus4F(PC),
        .InstrF(InstrF),
        .PCPlus8D(PCPlus8D),
        .InstrD(InstrD)
    );

    // Decode Stage
    decode_stg decode_stage (
        .clk(clk),
        .reset(reset),
        .InstrD(InstrD),
        .Flags(RegWrite),
        .RegSrcD(MemToReg),
        .ImmSrcD(MemWrite),
        .PCPlus8D(PCPlus8D),
        .ResultW(ALUOutW),
        .WA3W(WA3W),
        .ExtImm(ExtImmD),
        .RD1(RD1D),
        .RD2(RD2D)
    );

    // ID/EX Pipeline Register
    decode_execute id_ex (
        .clk(clk),
        .reset(reset),
        .PCPlus8D(PCPlus8D),
        .ExtImm(ExtImmD),
        .RD1(RD1D),
        .RD2(RD2D),
        .WA3D(WA3D),
        .RegWriteD(RegWriteD),
        .MemToRegD(MemToRegD),
        .MemWriteD(MemWriteD),
        .PCPlus8E(PCPlus8E),
        .ExtImmE(ExtImmE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .WA3E(WA3E),
        .RegWriteE(RegWriteE),
        .MemToRegE(MemToRegE),
        .MemWriteE(MemWriteE)
    );

    // Execute Stage
    execute_stg execute_stage (
        .SrcAE(RD1E),
        .WriteData(RD2E),
        .ExtImmE(ExtImmE),
        .ALUSrcE(ALUSrc),
        .ALUControlE(ALUControl),
        .ALUFlags(ALUFlags),
        .WA3(WA3M),
        .WriteDataE(WriteDataE),
        .ALUResultE(ALUResultE)
    );

    // EX/MEM Pipeline Register
    execute_memory ex_mem (
        .clk(clk),
        .reset(reset),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .WA3E(WA3M),
        .PCSrcE(PCSrc),
        .RegWriteE(RegWriteE),
        .MemToRegE(MemToRegE),
        .MemWriteE(MemWriteE),
        .ALUOutM(ALUOutM),
        .WriteDataM(WriteDataM),
        .WA3M(WA3M),
        .RegWriteM(RegWriteM),
        .MemToRegM(MemToRegM),
        .MemWriteM(MemWriteM)
    );

    // Memory Stage
    memory_stg memory_stage (
        .clk(clk),
        .reset(reset),
        .MemWriteM(MemWriteM),
        .ALUResultE(ALUOutM),
        .WriteDataE(WriteDataM),
        .WA3E(WA3M),
        .ALUOutM(ALUOutW),
        .WA3M(WA3W),
        .RD(ReadDataW)
    );

    // MEM/WB Pipeline Register
    memory_write mem_wb (
        .clk(clk),
        .reset(reset),
        .ALUOutM(ALUOutW),
        .RD(ReadDataW),
        .WA3M(WA3W),
        .RegWriteM(RegWriteM),
        .MemToRegM(MemToRegM),
        .ALUOutW(ALUOutW),
        .ReadDataW(ReadDataW),
        .WA3W(WA3W),
        .RegWriteW(RegWriteW),
        .MemToRegW(MemToRegW)
    );

    // Write Back Stage
    write_stg write_stage (
        .MemToRegW(MemToRegW),
        .ALUOutW(ALUOutW),
        .ReadDataW(ReadDataW),
        .WA3M(WA3W),
        .WA3W(WA3W),
        .ResultW(ResultW)
    );

endmodule

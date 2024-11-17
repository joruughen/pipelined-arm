`timescale 1ns / 1ps

module datapath (
    input wire clk,
    input wire reset,
    // control signals
    input wire PCSrcW,
    input wire [1:0] RegSrcD,
    input wire [1:0] ImmSrcD,
    input wire ALUSrcE,
    input wire [2:0] ALUControlE,
    // datapath signals
    output wire [31:0] PCF,
    output wire [31:0] InstrF,
    output wire [3:0] ALUFlags, 
    output wire [31:0] ALUResultE,
    output wire [31:0] WriteDataE,
    output wire [31:0] ReadDataM,
    output wire [31:0] ResultW
);


wire [31:0] WriteDataM;
/*wire RegWriteW;
wire MemToRegW;
*/
// FETCH 
wire [31:0] PCPlus8D;

// DECODE
wire [31:0] InstrD;
wire [31:0] ExtImmD;
wire [31:0] RD1D;
wire [31:0] RD2D;
wire RegWriteD;
wire MemToRegD;
wire MemWriteD;
//wire [1:0] ImmSrcD;
wire [3:0] WA3W;
wire [3:0] WA3D;
wire [2:0] ALUControlD;
wire [3:0] Flags;
wire [1:0] FlagWriteD;


// EXECUTE
wire [31:0] ExtImmE;
wire [31:0] RD1E;
wire [31:0] RD2E;
wire [3:0] WA3E;
wire RegWriteE;
wire MemToRegE;
wire MemWriteE;
//wire [31:0] WriteDataE;
//wire ALUSrcE;
wire PCSrcE;
wire [3:0] FlagsE;
wire [1:0] FlagWriteE;
 
// MEMORY STAGE
wire PCSrcM;
wire RegWriteM; //
wire MemToRegM; // 
wire MemWriteM; // 
wire [31:0] ALUResultM; //
wire [3:0] WA3M; // 
wire [31:0] ALUOutM; 


// WRITE
wire [31:0] ReadDataW; //
wire [31:0] ALUOutW; //

fetch_stg fetch_stage(
    .clk(clk),
    .reset(reset),
    .PCSrcW(PCSrcW),
    .ResultW(ResultW),
    .InstrF(InstrF),
    .PCPlus8D(PCPlus8D),
    .PCF(PCF)
);

fetch_decode f_d(
    .clk(clk),
    .reset(reset),
    .InstrF(InstrF),
    .InstrD(InstrD)
);

decode_stg decode_stage(
    .clk(clk),
    .reset(reset),
    .InstrD(InstrD),
    .RegWriteW(RegWriteW),
    .RegSrcD(RegSrcD),
    .ImmSrcD(ImmSrcD),
    .PCPlus8D(PCPlus8D),
    .ResultW(ResultW),
    .WA3D(WA3D),
    .WA3W(WA3D),
    .ExtImmD(ExtImmD),
    .RD1D(RD1D),
    .RD2D(RD1D)
);


decode_execute d_e(
    .clk(clk),
    .reset(reset),
    .PCSrcD(PCSrcD),
    .RegWriteD(RegWriteD),
    .MemToRegD(MemToRegD),
    .MemWriteD(MemWriteD),
    .ALUControlD(ALUControlD), 
    .BranchD(BranchD),
    .ALUSrcD(ALUSrcD),
    .FlagWriteD(FlagWriteD),
    .ImmSrcD(ImmSrcD),
    .Flags(Flags),
    .CondD(CondD),
    .ExtImmD(ExtImmD),
    .RD1D(RD1D), 
    .RD2D(RD2D),
    .WA3D(WA3D),
    .PCSrcE(PCSrcE),
    .RegWriteE(RegWriteE),
    .MemToRegE(MemToRegE),
    .MemWriteE(MemWriteE),
    .ALUControlE(ALUControlE),
    .BranchE(BranchE),
    .ALUSrcE(ALUSrcE),
    .FlagWriteE(FlagWriteE),
    .FlagsE(FlagsE),
    .CondE(CondE),
    .ExtImmE(ExtImmE),
    .RD1E(RD1E),
    .RD2E(RD2E),
    .WA3E(WA3E)
);


execute_stg execute_stage(
    .RD1E(RD1E),
    .RD2E(RD2E),
    .ExtImmE(ExtImmE),
    .ALUSrcE(ALUSrcE),
    .ALUControlE(ALUControlE),
    .ALUFlags(ALUFlags),
    .ALUResultE(ALUResultE),
    .WriteDataE(WriteDataE)
);


execute_memory e_m(
    .clk(clk),
    .reset(reset),
    .PCSrcE(PCSrcE),
    .RegWriteE(RegWriteE),
    .MemToRegE(MemToRegE),
    .MemWriteE(MemWriteE),
    .ALUResultE(ALUResultE),
    .WriteDataE(WriteDataE),
    .WA3E(WA3E),
    .PCSrcM(PCSrcM),
    .RegWriteM(RegWriteM),
    .MemToRegM(MemToRegM),
    .MemWriteM(MemWriteM),
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .WA3M(WA3M)
);


memory_stg memory_stage(
    .clk(clk),
    .reset(reset),
    .MemWriteM(MemWriteM),
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .ALUOutM(ALUOutM),
    .ReadDataM(ReadDataM)
);

memory_write m_w(
    .clk(clk),
    .reset(reset),
    .ReadDataM(ReadDataM),
    .ALUOutM(ALUOutM),
    .WA3M(WA3M),
    .PCSrcM(PCSrcM),
    .RegWriteM(RegWriteM),
    .MemToRegM(MemToRegM),
    .ReadDataW(ReadDataW),
    .ALUOutW(ALUOutW),
    .WA3W(WA3W),
    .PCSrcW(PCSrcW),
    .RegWriteW(RegWriteW),
    .MemToRegW(MemToRegW)
);

write_stg write_stage(
    .MemToRegW(MemToRegW),
    .ALUOutW(ALUOutW),
    .ReadDataW(ReadDataW),
    .ResultW(ResultW)
);

endmodule

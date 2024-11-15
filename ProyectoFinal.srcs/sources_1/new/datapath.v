module datapath (
    clk,
    reset,
    ResultW
);

input wire clk;
input wire reset;
output wire [31:0] ResultW;

// Señales internas entre etapas y registros de pipeline

// Fetch to IF/ID
wire [31:0] PCPlus4F;
wire [31:0] InstrF;

// IF/ID to Decode
wire [31:0] PCPlus8D;
wire [31:0] InstrD;

// Decode to ID/EX
wire [31:0] ExtImm;
wire [31:0] RD1;
wire [31:0] RD2;
wire [3:0] WA3D;
wire RegWriteD;
wire MemToRegD;
wire MemWriteD;

// ID/EX to Execute
wire [31:0] ExtImmE;
wire [31:0] RD1E;
wire [31:0] RD2E;
wire [3:0] WA3E;
wire RegWriteE;
wire MemToRegE;
wire MemWriteE;

// Execute to EX/MEM
wire [31:0] ALUOutM;
wire [31:0] WriteDataM;
wire [3:0] WA3M;
wire RegWriteM;
wire MemToRegM;
wire MemWriteM;

// MEM/WB to Write Back
wire [31:0] ALUOutW;
wire [31:0] ReadDataW;
wire [3:0] WA3W;
wire RegWriteW;
wire MemToRegW;

// Etapa Fetch (Fetch Stage)
fetch_stg fetch_stage (
    .clk(clk),
    .reset(reset),
    .Flags(1'b0),  // Temporalmente no se usa control de flujo
    .ResultW(32'b0),  // Temporalmente no se usa control de flujo
    .PCF(PCPlus4F),
    .InstrF(InstrF)
);

// Registro IF/ID
fetch_decode if_id (
    .clk(clk),
    .reset(reset),
    .PCPlus4F(PCPlus4F),
    .InstrF(InstrF),
    .PCPlus8D(PCPlus8D),
    .InstrD(InstrD)
);

// Etapa Decode
decode_stg decode_stage (
    .clk(clk),
    .reset(reset),
    .InstrD(InstrD),
    .Flags(RegWriteD),
    .RegSrcD(MemToRegD),
    .ImmSrcD(MemWriteD),
    .PCPlus8D(PCPlus8D),
    .ResultW(ResultW),
    .WA3W(WA3W),
    .ExtImm(ExtImm),
    .RD1(RD1),
    .RD2(RD2)
);

// Registro ID/EX
decode_execute id_ex (
    .clk(clk),
    .reset(reset),
    .PCPlus8D(PCPlus8D),
    .ExtImm(ExtImm),
    .RD1(RD1),
    .RD2(RD2),
    .WA3D(WA3D),
    .RegWriteD(RegWriteD),
    .MemToRegD(MemToRegD),
    .MemWriteD(MemWriteD),
    .PCPlus8E(ExtImmE),
    .RD1E(RD1E),
    .RD2E(RD2E),
    .WA3E(WA3E),
    .RegWriteE(RegWriteE),
    .MemToRegE(MemToRegE),
    .MemWriteE(MemWriteE)
);

// Etapa Execute
execute_stg execute_stage (
    .SrcAE(RD1E),
    .WriteData(RD2E),
    .ExtImmE(ExtImmE),
    .ALUSrcE(MemToRegE),
    .ALUControlE(MemWriteE),
    .ALUFlags(WA3E),
    .WA3(WA3M),
    .WriteDataE(WriteDataM),
    .ALUResultE(ALUOutM)
);

// Registro EX/MEM
execute_memory ex_mem (
    .clk(clk),
    .reset(reset),
    .ALUResultE(ALUOutM),
    .WriteDataE(WriteDataM),
    .WA3E(WA3M),
    .RegWriteE(RegWriteE),
    .MemToRegE(MemToRegE),
    .MemWriteE(MemWriteM),
    .ALUOutM(ALUOutW),
    .WriteDataM(ReadDataW),
    .WA3M(WA3W),
    .RegWriteM(RegWriteM),
    .MemToRegM(MemToRegM),
    .MemWriteM(MemWriteM)
);

// Etapa Memory
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

// Registro MEM/WB
memory_write mem_wb (
    .clk(clk),
    .reset(reset),
    .ALUOutM(ALUOutW),
    .RD(ReadDataW),
    .WA3M(WA3W),
    .RegWriteM(RegWriteM),
    .MemToRegM(MemToRegM),
    .ALUOutW(ResultW),
    .ReadDataW(ReadDataW),
    .WA3W(WA3W),
    .RegWriteW(RegWriteW),
    .MemToRegW(MemToRegW)
);

// Etapa Write Back
write_stg write_stage (
    .MemToRegW(MemToRegW),
    .ALUOutW(ALUOutW),
    .ReadDataW(ReadDataW),
    .WA3M(WA3W),
    .WA3W(WA3W),
    .ResultW(ResultW)
);

endmodule

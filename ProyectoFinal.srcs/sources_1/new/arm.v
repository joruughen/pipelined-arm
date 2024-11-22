module arm (
	clk,
	reset,
	PC,
	InstrF,
	MemWrite,
	ALUResult,
	WriteData,
	ReadData
);
	input wire clk;
	input wire reset;
	output wire [31:0] PC;
	input wire [31:0] InstrF;
	output wire MemWrite;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [3:0] ALUFlags;
	wire RegWrite;
	wire ALUSrc;
	wire MemtoReg;
	wire PCSrc;
	wire [1:0] RegSrc;
	wire [1:0] ImmSrc;
	wire [1:0] ALUControl;
	wire [31:0] ExtImm;
	wire [31:0] RD1D;
	wire [31:0] RD2D;
	
	wire BranchTakenE;
	
	controller c(
		.clk(clk),
		.reset(reset),
		.InstrD(InstrF),
		.ALUFlags(ALUFlags),
		.RegSrcD(RegSrc),
		.RegWriteW(RegWrite),
		.ImmSrcD(ImmSrc),
		.ALUSrcE(ALUSrc),//
		.ALUControlE(ALUControl),
		.MemWriteM(MemWrite),//
		.MemtoRegW(MemtoReg),
		.PCSrcW(PCSrc),
		//.ExtImmE(ExtImm),
		.BranchTakenE(BranchTakenE)
	);
	datapath dp(
		.clk(clk),
		.reset(reset),
		.RegSrcD(RegSrc),
		.RegWriteW(RegWrite),
		.ImmSrcD(ImmSrc),
		.ALUSrcE(ALUSrc),
		.ALUControlE(ALUControl),
		.MemtoRegW(MemtoReg),
		.PCSrcW(PCSrc),
		.ALUFlags(ALUFlags),
		.PCF(PC),
		.InstrF(InstrF),
		.ALUOutM(ALUResult),
		.WriteDataE(WriteData),
		.ReadDataM(ReadData),
		.ExtImmD(ExtImm), 
		//.CondD(CondD),
		.RD1D(RD1D), 
		.RD2D(RD2D),
		.BranchTakenE(BranchTakenE)
	);
endmodule
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
	controller c(
		.clk(clk),
		.reset(reset),
		.InstrD(InstrF[31:12]),
		.ALUFlags(ALUFlags),
		.RegSrcD(RegSrc),
		.RegWriteD(RegWrite),
		.ImmSrcD(ImmSrc),
		.ALUSrcD(ALUSrc),
		.ALUControlD(ALUControl),
		.MemWriteD(MemWrite),
		.MemtoRegD(MemtoReg),
		.PCSrcD(PCSrc)
	);
	datapath dp(
		.clk(clk),
		.reset(reset),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc),
		.ALUFlags(ALUFlags),
		.PCF(PC),
		.InstrF(InstrF),
		.ALUResult(ALUResult),
		.WriteData(WriteData),
		.ReadData(ReadData)
	);
endmodule
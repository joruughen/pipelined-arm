module top (
	clk,
	reset,
	WriteData,
	DataAdr,
	MemWrite
);
	input wire clk;
	input wire reset;
	output wire [31:0] WriteData;
	output wire [31:0] DataAdr;
	output wire MemWrite;
	wire [31:0] PC;
	wire [31:0] InstrF;
	wire [31:0] ReadData;
	arm arm(
		.clk(clk),
		.reset(reset),
		.PC(PC),
		.InstrF(InstrF),
		.MemWrite(MemWrite),
		.ALUResult(DataAdr),
		.WriteData(WriteData),
		.ReadData(ReadData)
	);
	imem imem(
		.a(PC),
		.rd(InstrF)
	);
	dmem dmem(
		.clk(clk),
		.we(MemWrite),
		.a(DataAdr),
		.wd(WriteData),
		.rd(ReadData)
	);
endmodule
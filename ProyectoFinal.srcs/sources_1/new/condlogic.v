module condlogic (
	clk,
	reset,
	Cond,
	ALUFlags,
	FlagW,
	PCS,
	RegW,
	MemW,
	PCSrc,
	RegWrite,
	MemWrite,
	Branch,
	BranchTakenE,
	FlagsPrima,
	NoW,
	FlushE
);
	input wire clk;
	input wire reset;
	input wire [3:0] Cond;
	input wire [3:0] ALUFlags;
	input wire [1:0] FlagW;
	input wire PCS;
	input wire [1:0] RegW;
	input wire MemW;
	input wire Branch;
	input wire NoW;
	input wire FlushE;
	output wire PCSrc;
	output wire [1:0] RegWrite;
	output wire MemWrite;
	output wire BranchTakenE;
	output wire [3:0] FlagsPrima;
	wire [1:0] FlagWrite;
	wire [3:0] Flags;
	wire CondEx;
	flopenrc #(2) flagreg1(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[1]),
		.clear(FlushE),
		.d(ALUFlags[3:2]),
		.q(Flags[3:2])
	);
	flopenrc #(2) flagreg0(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[0]),
		.clear(FlushE),
		.d(ALUFlags[1:0]),
		.q(Flags[1:0])
	);
	condcheck cc(
		.Cond(Cond),
		.Flags(Flags),
		.CondEx(CondEx)
	);
	assign FlagWrite = FlagW & {2 {CondEx}};
	assign RegWrite = RegW & {CondEx, CondEx} & {~NoW, ~NoW};
	assign MemWrite = MemW & CondEx;
	assign PCSrc = PCS & CondEx;
	assign BranchTakenE = Branch & CondEx;
	assign FlagsPrima = Flags;
	
	
endmodule
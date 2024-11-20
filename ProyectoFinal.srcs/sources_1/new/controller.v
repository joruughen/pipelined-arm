module controller (
	clk,
	reset,
	InstrD,
	ALUFlags,
	RegSrcD,
	RegWriteD,
	ImmSrcD,
	ALUSrcD,
	ALUControlD,
	MemWriteD,
	MemtoRegD,
	PCSrcD
);
	input wire clk;
	input wire reset;
	//señales para decode stage
	input wire [31:12] InstrD;
	
	output wire [1:0] RegSrcD;
	output wire RegWriteD;
	output wire [1:0] ImmSrcD;
	output wire ALUSrcD;
	output wire [1:0] ALUControlD;
	output wire MemWriteD;
	output wire MemtoRegD;
	output wire PCSrcD;
	wire [3:0] CondD;
	

	
	//Para el puente entre Decoder y Conditional Logic
	wire FlagWD;
	wire PCS;
	wire RegW;
	wire MemW;
	
	
		input wire [3:0] ALUFlags;
assign PCSrcD = 1'b0;
/*	
	//señales para execute stage
	wire [31:12] InstrE;
	// wire [3:0] ALUFlags;
	wire [1:0] RegSrcE;
	wire RegWriteE;
	// wire [1:0] ImmSrcD;
	wire ALUSrcD;
	wire [1:0] ALUControlD;
	wire MemWriteD;
	wire MemtoRegD;
	wire PCSrcD;
	wire [3:0] Flags;
	 
*/	
	//Decode Stage
//	assign CondD = InstrD[31:28];
	decode dec(
		.Op(InstrD[27:26]),
		.Funct(InstrD[25:20]),
		.Rd(InstrD[15:12]),
		.FlagW(FlagWD),
		.PCS(PCSD),
		.RegW(RegWD),
		.MemW(MemWD),
		.MemtoReg(MemtoRegD),
		.ALUSrc(ALUSrcD),
		.ImmSrc(ImmSrcD),
		.RegSrc(RegSrcD),
		.ALUControl(ALUControlD)
	);
	
/*
	flopr D_to_E(
	   .clk(clk), 
	   .reset(reset),
	   .d({PCSrcD, RegWriteD, MemToRegD, MemWriteD, ALUControlD, BranchD, ALUSrcD, FlagWriteD, ImmSrcD, CondD, Flags}),
	   .q({})
	   
	)
*/
	
	condlogic cl(
		.clk(clk),
		.reset(reset),
		.Cond(InstrD[31:28]),
		.ALUFlags(ALUFlags),
		.FlagW(FlagWD),
		.PCS(PCSD),
		.RegW(RegWD),
		.MemW(MemWD),
		.PCSrc(PCSrcD),
		.RegWrite(RegWriteD),
		.MemWrite(MemWriteD)
	);
endmodule
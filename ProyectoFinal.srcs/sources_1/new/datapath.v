module datapath (
	clk,
	reset,
	RegSrcD,
	RegWrite,
	ImmSrcD,
	ALUSrc,
	ALUControl,
	MemtoReg,
	PCSrc,
	ALUFlags,
	PCF,
	InstrF,
	ALUResult,
	WriteData,
	ReadData, 
	ExtImm, // para el register de decode a execute
	CondD, // bits 15:12 de InstrD
	RD1D, // ReadData1 de register file
	RD2D // ReadData2 de register file
);

	input wire clk;
	input wire reset;
	input wire [1:0] RegSrcD;
	input wire RegWrite;
	input wire [1:0] ImmSrcD;
	input wire ALUSrc;
	input wire [1:0] ALUControl;
	input wire MemtoReg;
	input wire PCSrc;
	output wire [3:0] ALUFlags;
	output wire [31:0] PCF;
	input wire [31:0] InstrF;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	output wire [31:0] ExtImm;
	output wire [3:0] CondD;
    output wire [31:0] RD1D;
    output wire [31:0] RD2D;
        
	wire [31:0] PCNext;
	
	// wire [31:0] PCPlus4F;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] Result;
	wire [3:0] RA1;
	wire [3:0] RA2;
	
	
	// fetch stage
	//wire [31:0] ALUResultE; // proviene de execute
	wire BranchE; // proviene de execute
	wire [31:0] PCPlus4F;
	wire [31:0] PC;
	
	mux2 #(32) pcmux( //BranchE //PCSrcW //
		.d0(PCPlus4),
		.d1(Result),
		.s(PCSrc),
		.y(PCNext)
	);
	
	mux2 #(32) pcmux2(
		.d0(PCNext),
		.d1(ALUResultE),
		.s(BranchE),
		.y(PC)
	);
	wire StallF;
	flopenr #(32) pcreg(
		.clk(clk),
		.reset(reset),
		.en(~StallF),
		.d(PC),
		.q(PCF)
	);
	
	adder #(32) pcadd1(
		.a(PCF),
		.b(32'b100),
		.y(PCPlus4F)
	);
	
	
	wire [31:0] InstrD;
	// cambiar a rc
	flopr #(32) F_to_D (
	   .clk(clk),
	   .reset(reset),
	   .d(InstrF),
	   .q(InstrD)
	);
	

	/*
	adder #(32) pcadd2(
		.a(PCPlus4),
		.b(32'b100),
		.y(PCPlus8)
	);
	*/
	
	// decode stage

	mux2 #(4) ra1mux(
		.d0(InstrF[19:16]),
		.d1(4'b1111),
		.s(RegSrcD[0]),
		.y(RA1)
	);
	
	mux2 #(4) ra2mux(
		.d0(InstrF[3:0]),
		.d1(InstrF[15:12]),
		.s(RegSrcD[1]),
		.y(RA2)
	);
	wire [31:0] PCPlus8D;
	assign PCPlus8D = PCPlus4F;
	
	regfile rf(
		.clk(clk),
		.we3(RegWrite),
		.ra1(RA1),
		.ra2(RA2),
		.wa3(InstrF[15:12]),
		.wd3(Result),
		.r15(PCPlus8D),
		.rd1(RD1D),
		.rd2(RD2D)
	);
	
	extend ext(
		.Instr(InstrF[23:0]),
		.ImmSrc(ImmSrcD),
		.ExtImm(ExtImm)
	);
	
	assign CondD = InstrD[15:12];
	
	
	
	

	mux2 #(32) resmux(
		.d0(ALUResult),
		.d1(ReadData),
		.s(MemtoReg),
		.y(Result)
	);
	

	
	mux2 #(32) srcbmux(
		.d0(WriteData),
		.d1(ExtImm),
		.s(ALUSrc),
		.y(SrcB)
	);
	alu alu(
		SrcA,
		SrcB,
		ALUControl,
		ALUResult,
		ALUFlags
	);

endmodule
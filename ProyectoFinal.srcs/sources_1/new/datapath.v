module datapath (
	clk,
	reset,
	RegSrcD,
	RegWriteW,
	ImmSrcD,
	ALUSrcE,
	ALUControlE,
	MemtoRegW,
	PCSrcW,
	ALUFlags,
	PCF,
	InstrF,
	ALUOutM,
	WriteDataE,
	ReadDataM, 
	ExtImmD, // para el register de decode a execute
	//CondD, // bits 15:12 de InstrD
	RD1D, // ReadData1 de register file
	RD2D, // ReadData2 de register file
	BranchTakenE
);

	input wire clk;
	input wire reset;
	input wire [1:0] RegSrcD;
	input wire RegWriteW;
	input wire [1:0] ImmSrcD;
	input wire ALUSrcE;
	input wire [1:0] ALUControlE;
	input wire MemtoRegW;
	input wire PCSrcW;
	output wire [3:0] ALUFlags;
	output wire [31:0] PCF;
	input wire [31:0] InstrF;
	output wire [31:0] ALUOutM;
	output wire [31:0] WriteDataE;
	input wire [31:0] ReadDataM;
	output wire [31:0] ExtImmD;
	//output wire [3:0] CondD;
    output wire [31:0] RD1D;
    output wire [31:0] RD2D;
        
	wire [31:0] PCNext;
	
	// wire [31:0] PCPlus4F;

	wire [31:0] ResultW;
	wire [3:0] RA1D;
	wire [3:0] RA2D;
	
	
	//writeback wa3
	wire [3:0] WA3W;
	//
	
	
	// fetch stage
	wire [31:0] ALUResultE; // proviene de execute
	input wire BranchTakenE; // proviene de execute
	wire [31:0] PCPlus4F;
	wire [31:0] PC;
	
	mux2 #(32) pcmux( //BranchE //PCSrcW //
		.d0(PCPlus4F),
		.d1(ResultW),
		.s(PCSrcW),
		.y(PCNext)
	);
	//assign BranchTakenE = 0;// cambiar tempora
	
	mux2 #(32) pcmux2(
		.d0(PCNext),
		.d1(ALUResultE),
		.s(BranchTakenE),
		.y(PC)
	);
	wire StallF;
	assign StallF = 0;// cambiar tempora
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

    //antes en assign CondD = InstrD[15:12];
	//assign CondD = InstrD[31:28];

	mux2 #(4) ra1mux(
		.d0(InstrF[19:16]),
		.d1(4'b1111),
		.s(RegSrcD[0]),
		.y(RA1D)
	);
	
	mux2 #(4) ra2mux(
		.d0(InstrF[3:0]),
		.d1(InstrF[15:12]),
		.s(RegSrcD[1]),
		.y(RA2D)
	);
	wire [31:0] PCPlus8D;
	assign PCPlus8D = PCPlus4F;
	
	regfile rf(
		.clk(clk),
		.we3(RegWriteW),
		.ra1(RA1D),
		.ra2(RA2D),
		.wa3(WA3W),
		.wd3(ResultW),
		.r15(PCPlus8D),
		.rd1(RD1D),
		.rd2(RD2D)
	);
	
	extend ext(
		.Instr(InstrF[23:0]),
		.ImmSrc(ImmSrcD),
		.ExtImm(ExtImmD)
	);
	
	wire [31:0] RD1E;
	wire [31:0] RD2E;
	wire [31:0] ExtImmE;
	wire [3:0] WA3E;
	wire [3:0] RA1E;
	wire [3:0] RA2E;
	
	//Flops Execute
	
	flopr #(32) rd1reg(
        .clk(clk), 
        .reset(reset), 
        .d(RD1D), 
        .q(RD1E)
    );
    flopr #(32) rd2reg(
        .clk(clk), 
        .reset(reset), 
        .d(RD2D), 
        .q(RD2E)
    );
    flopr #(32) immreg(
        .clk(clk), 
        .reset(reset), 
        .d(ExtImmD), 
        .q(ExtImmE)
    );
    flopr #(4) wa3ereg(
        .clk(clk), 
        .reset(reset), 
        .d(InstrD[15:12]), 
        .q(WA3E)
    );
    flopr #(4) ra1reg(
        .clk(clk), 
        .reset(reset), 
        .d(RA1D), 
        .q(RA1E)
    );
    flopr #(4) ra2reg(
        .clk(clk), 
        .reset(reset), 
        .d(RA2D), 
        .q(RA2E)
    );
	
	
	wire [3:0] ALUOutM;
	wire [31:0] SrcAE;
	wire [31:0] SrcBE;
	
	wire [1:0] ForwardAE, ForwardBE;
	assign ForwardAE = 2'b00;
	assign ForwardBE = 2'b00; //cambiar temporal
	
	mux3 #(32) MSrcAE(
		.d0(RD1E),
		.d1(ResultW),
		.d2(ALUOutM),
		.s(ForwardAE),
		.y(SrcAE)
	);
	
	
	mux3 #(32) MSrcBE(
		.d0(RD2E),
		.d1(ResultW),
		.d2(ALUOutM), /////
		.s(ForwardBE),
		.y(WriteDataE)
	);
	
	mux2 #(32) MSrcBE2(
	    .d0(WriteDataE),
        .d1(ExtImmE),
	    .s(ALUSrcE),
		.y(SrcBE)
	);
	
	alu alu(
		SrcAE,
		SrcBE,
		ALUControlE,
		ALUResultE,
		ALUFlags
	);
	
    //	Memory Stage
    
    wire [31:0] ALUOutM, WriteDataM;
	wire [3:0] WA3M;
	
    //Flops Memory
	
	flopr #(32) aluresreg(.clk(clk), .reset(reset), .d(ALUResultE), .q(ALUOutM));
    flopr #(32) wdreg(.clk(clk), .reset(reset), .d(WriteDataE), .q(WriteDataM));
    flopr #(4) wa3mreg(.clk(clk), .reset(reset), .d(WA3E), .q(WA3M));
    
    wire [31:0] ReadDataW;
    wire [31:0] ALUOutW;
    
    
	
    
    // Writeback Stage
    flopr #(32) aluoutreg(.clk(clk), .reset(reset), .d(ALUOutM), .q(ALUOutW));
    flopr #(32) rdreg(.clk(clk), .reset(reset), .d(ReadDataM), .q(ReadDataW));
    flopr #(4) wa3wreg(.clk(clk), .reset(reset), .d(WA3M), .q(WA3W));
    
    
    mux2 #(32) resmux(.d0(ALUOutW), .d1(ReadDataW), .s(MemtoRegW), .y(ResultW));	
    
    
	

endmodule
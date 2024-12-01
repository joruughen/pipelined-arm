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
	ALUOut1M,
	ALUOut2M,
	WriteDataE,
	ReadDataM,
	InstrD,
	ExtImmD, // para el register de decode a execute
	//CondD, // bits 15:12 de InstrD
	RD1D, // ReadData1 de register file
	RD2D, // ReadData2 de register file
	BranchTakenE,
	MemtoRegE,
	
	//Para Hazard Forwarding
    Match_1E_M, 
    Match_1E_W, 
    Match_2E_M,
    Match_2E_W,
    ForwardAE,
    ForwardBE,
    Match_12D_E,
    StallF,
    StallD,
    FlushE,
    FlushD,
    //para instrucciones
    N, 
	Long,
	Signed,
	Carry, 
	Inv,
	FlagsPrima
	//
);

    //Para las instrucciones
    input wire [3:0] FlagsPrima;
    input wire  N, Long, Signed, Carry, Inv;
    
    //

    //Hazard perdon por el desorden
    
    output wire Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E;
        
    input wire [1:0] ForwardAE, ForwardBE;
    input wire MemtoRegE, StallF, StallD, FlushE, FlushD;
    
    //
    //Execute signals
    wire [31:0] RD1E;
	wire [31:0] RD2E;
	wire [31:0] ExtImmE;
	wire [3:0] WA4D;
	wire [3:0] WA5D;
	wire [3:0] WA5E;
	wire [3:0] WA5E;
	wire [3:0] RA1E;
	wire [3:0] RA2E;
	
   // wire [3:0] ALUOutM;
	wire [31:0] SrcAE;
	wire [31:0] SrcBE;
	wire [31:0] SrcCE;
    //
    //Memory signals
    wire [31:0] ALUOut1M, ALUOut2M, WriteDataM;
	wire [3:0] WA4M, WA5M;
	//
	//WriteBack Signals
	wire [31:0] ReadDataW;
    wire [31:0] ALUOut1W, ALUOut2M;
    //

	input wire clk;
	input wire reset;
	input wire [5:0] RegSrcD;
	input wire [1:0] RegWriteW;
	input wire [1:0] ImmSrcD;
	input wire ALUSrcE;
	input wire [2:0] ALUControlE;
	input wire MemtoRegW;
	input wire PCSrcW;
	output wire [3:0] ALUFlags;
	output wire [31:0] PCF;
	input wire [31:0] InstrF;
	output wire [31:0] InstrD;
	output wire [31:0] ALUOut1M;
	output wire [31:0] ALUOut2M;
	output wire [31:0] WriteDataE;
	input wire [31:0] ReadDataM;
	output wire [31:0] ExtImmD;
	//output wire [3:0] CondD;
    output wire [31:0] RD1D;
    output wire [31:0] RD2D;
        
	wire [31:0] PCNext;
	
	// wire [31:0] PCPlus4F;

	wire [31:0] ResultW1;
	wire [31:0] ResultW2;
	wire [3:0] RA1D;
	wire [3:0] RA2D;
	wire [3:0] RA3D;
	
	
	//writeback wa4/4
	wire [3:0] WA4W;
	wire [3:0] WA5W;
	//
	
	
	// fetch stage
	wire [31:0] ALUResult1E; // proviene de execute
	wire [31:0] ALUResult2E; // proviene de execute
	input wire BranchTakenE; // proviene de execute
	wire [31:0] PCPlus4F;
	wire [31:0] PC;
	
	mux2 #(32) pcmux( //BranchE //PCSrcW //
		.d0(PCPlus4F),
		.d1(ResultW1),
		.s(PCSrcW),
		.y(PCNext)
	);
	
	
	mux2 #(32) pcmux2(
		.d0(PCNext),
		.d1(ALUResult1E),
		.s(BranchTakenE),
		.y(PC)
	);
	
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
	
	
	// cambiar a rc
	flopenrc #(32) F_to_D (
	   .clk(clk),
	   .reset(reset),
	   .d(InstrF),
	   .q(InstrD),
	   .en(~StallD),
	   .clear(FlushD)
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

	mux3 #(4) ra1mux(
		.d0(InstrD[19:16]),
		.d1(4'b1111),
		.d2(InstrD[3:0]),
		.s(RegSrcD[5:4]),
		.y(RA1D)
	);
	
	mux3 #(4) ra2mux(
		.d0(InstrD[3:0]),
		.d1(InstrD[15:12]),
		.d2(InstrD[11:8]),
		.s(RegSrcD[3:2]),
		.y(RA2D)
	);
	
	mux2 #(4) ra3mux(
	   .d0(InstrD[15:12]),
	   .d1(InstrD[11:8]),
	   .s(RegSrcD[1]),
	   .y(RA3D)
	);
	
	wire [31:0] PCPlus8D;
	assign PCPlus8D = PCPlus4F;
	
	regfile rf(
		.clk(clk),
		.we(RegWriteW),
		.ra1(RA1D),
		.ra2(RA2D),
		.ra3(RA3D),
		.wa4(WA4W),
		.wa5(WA5W),
		.wd4(ResultW1),
		.wd5(ResultW2),
		.r15(PCPlus8D),
		.rd1(RD1D),
		.rd2(RD2D),
		.rd3(RD3D)
	);
	
	extend ext(
		.Instr(InstrD[23:0]),
		.ImmSrc(ImmSrcD),
		.ExtImm(ExtImmD)
	);
	
	
	
	//Flops Execute
	
	floprc #(32) rd1reg(
        .clk(clk), 
        .reset(reset), 
        .d(RD1D), 
        .q(RD1E),
        .clear(FlushE)
    );
    floprc #(32) rd2reg(
        .clk(clk), 
        .reset(reset), 
        .d(RD2D), 
        .q(RD2E),
        .clear(FlushE)
    );
    floprc #(32) rd3reg(
        .clk(clk), 
        .reset(reset), 
        .d(RD3D), 
        .q(RD3E),
        .clear(FlushE)
    );
    floprc #(32) immreg(
        .clk(clk), 
        .reset(reset), 
        .d(ExtImmD), 
        .q(ExtImmE),
        .clear(FlushE)
    );
    flopr #(4) wa4ereg(
        .clk(clk), 
        .reset(reset), 
        .d(InstrD[15:12]), 
        .q(W43E)
    );
    //assign WA3E = InstrD[15:12];//cambio
    
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
	
	flopr #(4) ra3reg(
        .clk(clk), 
        .reset(reset), 
        .d(RA3D), 
        .q(RA3E)
    );
	

	
    
	
	mux3 #(32) MSrcAE(
		.d0(RD1E),
		.d1(ResultW1),
		.d2(ALUOut1M),
		.s(ForwardAE),
		.y(SrcAE)
	);
	
	
	mux3 #(32) MSrcBE(
		.d0(RD2E),
		.d1(ResultW1),
		.d2(ALUOut1M), /////
		.s(ForwardBE),
		.y(WriteDataE)
	);
	
	mux2 #(32) MSrcBE2(
	    .d0(WriteDataE),
        .d1(ExtImmE),
	    .s(ALUSrcE),
		.y(SrcBE)
	);
	//añadir msrcc con forward signals
	assign SrcCE = RD3E;
	
	alu alu(
		SrcAE,
		SrcBE,
		SrcCE,
		ALUControlE,
		ALUResult1E,
		ALUResult2E,
		ALUFlags,
		N,
		Now,
		Long,
		Signed,
		Carry,
		Inv,
		FlagsPrima
	);
	
    //	Memory Stage
    
   
	
    //Flops Memory
	
	flopr #(32) alures1reg(.clk(clk), .reset(reset), .d(ALUResult1E), .q(ALUOut1M));
	flopr #(32) alures2reg(.clk(clk), .reset(reset), .d(ALUResult2E), .q(ALUOut2M));
    flopr #(32) wdreg(.clk(clk), .reset(reset), .d(WriteDataE), .q(WriteDataM));
    flopr #(4) wa4mreg(.clk(clk), .reset(reset), .d(WA4E), .q(WA4M));
    flopr #(4) wa5mreg(.clk(clk), .reset(reset), .d(WA5E), .q(WA5M));
    
    

    
    
	
    
    // Writeback Stage
    flopr #(32) aluout1reg(.clk(clk), .reset(reset), .d(ALUOut1M), .q(ALUOut1W));
    flopr #(32) aluout2reg(.clk(clk), .reset(reset), .d(ALUOut2M), .q(ALUOut2W));
    flopr #(32) rdreg(.clk(clk), .reset(reset), .d(ReadDataM), .q(ReadDataW));
    flopr #(4) wa4wreg(.clk(clk), .reset(reset), .d(WA4M), .q(WA4W));
    flopr #(4) wa5wreg(.clk(clk), .reset(reset), .d(WA5M), .q(WA5W));
    
    
    mux2 #(32) res1mux(.d0(ALUOut1W), .d1(ReadDataW), .s(MemtoRegW), .y(ResultW1));	
    assign ResultW2 = ALUOut2W;
    
    
    //Hazard Forwarding Devolviendo señales
	
	assign Match_1E_M = (RA1E == WA4M);
    assign Match_1E_W = (RA1E == WA4W);
    assign Match_2E_M = (RA2E == WA4M);
    assign Match_2E_W = (RA2E == WA4W);
    
    // añadir señales para wa5w
	
	assign Match_12D_E = (RA1D == WA4E) | (RA2D == WA4E);
	
	//

	

endmodule
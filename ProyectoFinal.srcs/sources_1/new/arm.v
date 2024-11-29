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
	wire [1:0] RegWriteW;//RegWriteW
	wire [1:0] RegWriteM;//RegWriteM
	wire ALUSrc;
	wire MemtoReg;
	wire PCSrcW;
	wire [5:0] RegSrc;
	wire [1:0] ImmSrc;
	wire [2:0] ALUControl;
	wire [31:0] ExtImm;
	wire [31:0] RD1D;
	wire [31:0] RD2D;
	wire [31:0] InstrD;
	
	wire BranchTakenE;
	
	//Para Hazard Forwarding
	wire Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W;
    wire [1:0] ForwardAE, ForwardBE;
    wire Match_12D_E, FlushE, StallF, StallD, FlushD;
		//
	
	//para instrucciones 
	wire NE, LongE, SignedE, CarryE, InvE;
	wire [3:0] FlagsPrima;
	//
	
	
	controller c(
		.clk(clk),
		.reset(reset),
		.InstrD(InstrD),
		.ALUFlags(ALUFlags),
		.RegSrcD(RegSrc),
		.RegWriteW(RegWriteW),
		.RegWriteM(RegWriteM),
		.ImmSrcD(ImmSrc),
		.ALUSrcE(ALUSrc),//
		.ALUControlE(ALUControl),
		.MemWriteM(MemWrite),//
		.MemtoRegW(MemtoReg),
		.PCSrcW(PCSrcW),
		.PCSrcE(PCSrcE),
        .PCSrcD(PCSrcD),
        .PCSrcM(PCSrcM),
		//.ExtImmE(ExtImm),
		.BranchTakenE(BranchTakenE),
		.MemtoRegE(MemtoRegE),
		.FlushE(FlushE),
		.NE(NE),
		.LongE(LongE),
		.SignedE(SignedE),
		.CarryE(CarryE),
		.InvE(InvE),
		.FlagsPrima(FlagsPrima)		
	);
	datapath dp(
		.clk(clk),
		.reset(reset),
		.RegSrcD(RegSrc),
		.RegWriteW(RegWriteW),
		.ImmSrcD(ImmSrc),
		.ALUSrcE(ALUSrc),
		.ALUControlE(ALUControl),
		.MemtoRegW(MemtoReg),
		.PCSrcW(PCSrcW),
		.ALUFlags(ALUFlags),
		.PCF(PC),
		.InstrF(InstrF),
		.InstrD(InstrD),
		.ALUOutM(ALUResult),
		.WriteDataE(WriteData),
		.ReadDataM(ReadData),
		.ExtImmD(ExtImm), 
		//.CondD(CondD),
		.RD1D(RD1D), 
		.RD2D(RD2D),
		.BranchTakenE(BranchTakenE),
		.MemtoRegE(MemtoRegE),
		//Para Hazard Forwarding
		.Match_1E_M(Match_1E_M), 
        .Match_1E_W(Match_1E_W), 
        .Match_2E_M(Match_2E_M), 
        .Match_2E_W(Match_2E_W),
        .Match_12D_E(Match_12D_E),
        .ForwardAE(ForwardAE), 
        .ForwardBE(ForwardBE),
		.StallF(StallF),
		.StallD(StallD),
		.FlushE(FlushE),
		.FlushD(FlushD),
		//
		//Para las instrucciones
		.N(NE), 
		.Long(LongE),
		.Signed(SignedE),
		.Carry(CarryE), 
		.Inv(InvE),
		.FlagsPrima(FlagsPrima)
		//
	);
	
	hazard h(
        .clk(clk), 
        .reset(reset), 
        .Match_1E_M(Match_1E_M), 
        .Match_1E_W(Match_1E_W), 
        .Match_2E_M(Match_2E_M), 
        .Match_2E_W(Match_2E_W),
        .Match_12D_E(Match_12D_E),
        .RegWriteM(RegWriteM), 
        .RegWriteW(RegWriteW), 
        .BranchTakenE(BranchTakenE), 
        .MemtoRegE(MemtoRegE),
        .PCSrcW(PCSrcW),
        .PCSrcE(PCSrcE),
        .PCSrcD(PCSrcD),
        .PCSrcM(PCSrcM),
        .ForwardAE(ForwardAE), 
        .ForwardBE(ForwardBE),
        .StallF(StallF), 
        .StallD(StallD), 
        .FlushD(FlushD), 
        .FlushE(FlushE)
        );
endmodule
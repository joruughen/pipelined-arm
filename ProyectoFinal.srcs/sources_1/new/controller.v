module controller (
	clk,
	reset,
	InstrD,
	ALUFlags,
	RegSrcD,
	RegWriteW,
	RegWriteM,
	ImmSrcD,
	ALUSrcE,
	ALUControlE,
	MemWriteM,
	MemtoRegW,
	PCSrcW, 
	BranchTakenE
);
	input wire clk;
	input wire reset;
	//señales para decode stage
	input wire [31:0] InstrD;
	
	output wire [1:0] RegSrcD;
	output wire RegWriteW, RegWriteM;
	output wire [1:0] ImmSrcD;
	output wire ALUSrcE;
	output wire [1:0] ALUControlE;
	output wire MemWriteM;
	output wire MemtoRegW;
	output wire PCSrcW;

    //wires de decode
    
    wire PCSrcD, RegWriteD, MemWriteD, MemtoRegD, ALUSrcD, BranchD;
    wire [1:0] ALUControlD;

	

	
	//Para el puente entre Decoder y Conditional Logic
	wire [1:0] FlagWriteD;
	
	//Para execute
	output wire BranchTakenE;
	
	
	input wire [3:0] ALUFlags;

	decode dec(
		.Op(InstrD[27:26]),
		.Funct(InstrD[25:20]),
		.Rd(InstrD[15:12]),
		.FlagW(FlagWriteD),
		.PCS(PCSrcD),
		.RegW(RegWriteD),
		.MemW(MemWriteD),
		.MemtoReg(MemtoRegD),
		.ALUSrc(ALUSrcD),
		.ImmSrc(ImmSrcD),
		.RegSrc(RegSrcD),
		.ALUControl(ALUControlD),
		.Branch(BranchD)
	);
	
	
	
    wire PCSrcE;
    wire PCSrcEpostCondLogic;
    wire RegWriteE;
    wire RegWriteEpostCondLogic;
    wire MemtoRegE;
    wire MemWriteE;
    wire MemWriteEpostCondLogic;
    wire BranchE;
    wire ALUSrcE;
    wire [1:0] FlagWriteE;
    wire [3:0] CondE;
    assign CondE = InstrD[31:28];
    wire [3:0] FlagsE;
    wire [3:0] FlagsPrima;
    wire [1:0] ALUControlE;
    

    
    
    
    flopr #(14) DToEreg(
        .clk(clk), 
        .reset(reset), 
        .d({PCSrcD,RegWriteD, MemtoRegD,MemWriteD, ALUControlD,BranchD,ALUSrcD,FlagWriteD}), 
        .q({PCSrcE,RegWriteE, MemtoRegE,MemWriteE, ALUControlE,BranchE,ALUSrcE,FlagWriteE}));
    
    flopr #(4) FlagEreg(
        .clk(clk), 
        .reset(reset), 
        .d(FlagsPrima), 
        .q(FlagsE));
  
 
	condlogic cl(
		.clk(clk),
		.reset(reset),
		.Cond(CondE),
		.ALUFlags(ALUFlags),
		.FlagW(FlagWriteE),
		.PCS(PCSrcE),
		.RegW(RegWriteE),
		.MemW(MemWriteE),
		.PCSrc(PCSrcEpostCondLogic),
		.RegWrite(RegWriteEpostCondLogic),
		.MemWrite(MemWriteEpostCondLogic),
		.Branch(BranchE),
		.BranchTakenE(BranchTakenE),
		.FlagsE(FlagsE),
		.FlagsPrima(FlagsPrima)
	);
	
	wire PCSrcM, MemtoRegM, MemWriteM; // RegWriteM definido arriba como output wire
	
	//para memory stage
	flopr #(4) EtoMreg(
        .clk(clk), 
        .reset(reset), 
        .d({PCSrcEpostCondLogic, RegWriteEpostCondLogic, MemtoRegE, MemWriteEpostCondLogic}), 
        .q({PCSrcM, RegWriteM, MemtoRegM, MemWriteM}));
        
    //para write back
    flopr #(4) MtoWreg(
        .clk(clk), 
        .reset(reset), 
        .d({PCSrcM, RegWriteM, MemtoRegM }), 
        .q({PCSrcW, RegWriteW, MemtoRegW}));
     
	
	
	
	
endmodule
module hazard(
    clk,
    reset,
    Match_1E_M,
    Match_1E_W,
    Match_2E_M,
    Match_2E_W,
    ForwardAE,
    ForwardBE,
    RegWriteM,
    RegWriteW,
    MemtoRegE,
    Match_12D_E,
    FlushE,
    FlushD,
    StallF,
    StallD,
    PCSrcD,
    PCSrcE,
    PCSrcM,
    PCSrcW,
    BranchTakenE

);


    input wire clk, reset;
    input wire Match_1E_M, Match_1E_W, Match_2E_M,Match_2E_W, Match_12D_E;
    input wire [1:0] RegWriteM, RegWriteW;
    input wire MemtoRegE;
    input wire PCSrcD, PCSrcE, PCSrcM, PCSrcW;
    input wire BranchTakenE;
    output reg [1:0] ForwardAE, ForwardBE;
    output wire StallF, StallD;
    output wire FlushE, FlushD;

    wire LDRstall;
    wire PCWrPendingF;

// forwarding logic
    always@(*) 
        begin
            if (Match_1E_M & RegWriteM) ForwardAE = 2'b10;
            else if (Match_1E_W & RegWriteW) ForwardAE = 2'b01;
            else ForwardAE = 2'b00;
            if (Match_2E_M & RegWriteM) ForwardBE = 2'b10;
            else if (Match_2E_W & RegWriteW) ForwardBE = 2'b01;
            else ForwardBE = 2'b00;
    end

    assign PCWrPendingF = PCSrcD | PCSrcE | PCSrcM;
    assign LDRstall = Match_12D_E & MemtoRegE;
	assign StallF = LDRstall | PCWrPendingF;
	assign FlushE = LDRstall | BranchTakenE;
	assign StallD = LDRstall;
//assign ldrStallD = Match_12D_E & MemtoRegE;
//assign StallD = ldrStallD;
//assign StallF = ldrStallD | PCWrPendingF;
//assign FlushE = ldrStallD | BranchTakenE;
    assign FlushD = PCWrPendingF | PCSrcW | BranchTakenE;
endmodule
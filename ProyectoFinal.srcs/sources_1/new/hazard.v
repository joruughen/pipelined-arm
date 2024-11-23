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
    StallF,
    StallD

);


    input wire clk, reset;
    input wire Match_1E_M, Match_1E_W, Match_2E_M,Match_2E_W, Match_12D_E;
    input wire RegWriteM, RegWriteW;
    input wire MemtoRegE;
    //input wire BranchTakenE, MemtoRegE;
    //input wire PCWrPendingF, PCSrcW;
    output reg [1:0] ForwardAE, ForwardBE;
    output wire StallF, StallD;
    output wire FlushE; // FlushE;

    wire LDRstall;
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

    assign LDRstall = Match_12D_E & MemtoRegE;
	assign StallF = LDRstall;
	assign FlushE = LDRstall;
	assign StallD = LDRstall;
//assign ldrStallD = Match_12D_E & MemtoRegE;
//assign StallD = ldrStallD;
//assign StallF = ldrStallD | PCWrPendingF;
//assign FlushE = ldrStallD | BranchTakenE;
//assign FlushD = PCWrPendingF | PCSrcW | BranchTakenE;
endmodule
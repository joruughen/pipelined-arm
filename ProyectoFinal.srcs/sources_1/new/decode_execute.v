`timescale 1ns / 1ps

module decode_execute (
    clk, 
    reset, 
    PCSrcD,
    RegWriteD,
    MemToRegD,
    MemWriteD,
    ALUControlD,
    BranchD,
    ALUSrcD,
    FlagWriteD,
    ImmSrcD,
    Flags,
    CondD,
    ExtImmD,
    RD1D,
    RD2D,
    WA3D,
    PCSrcE,
    RegWriteE,
    MemToRegE,
    MemWriteE,
    ALUControlE,
    BranchE,
    ALUSrcE,
    FlagWriteE,
    FlagsE,
    CondE,
    ExtImmE,
    RD1E,
    RD2E,
    WA3E
);

input wire clk;
input wire reset;

// DECODE STAGE
// control signals
input wire PCSrcD;
input wire RegWriteD;
input wire MemToRegD;
input wire MemWriteD;
input wire [2:0] ALUControlD;
input wire BranchD;
input wire ALUSrcD;
input wire [1:0] FlagWriteD;
input wire [1:0] ImmSrcD;
input wire [3:0] Flags;
input wire CondD;
// datapath signals
input wire [31:0] ExtImmD;
input wire [31:0] RD1D;
input wire [31:0] RD2D;
input wire [3:0] WA3D;

// EXECUTE STAGE
// control signals
output reg PCSrcE;
output reg RegWriteE;
output reg MemToRegE;
output reg MemWriteE;
output reg [2:0] ALUControlE;
output reg BranchE;
output reg ALUSrcE;
output reg [1:0] FlagWriteE;
output reg [3:0] FlagsE;
output reg CondE;
// datapath signals 
output reg [31:0] ExtImmE;
output reg [31:0] RD1E;
output reg [31:0] RD2E;
output reg [3:0] WA3E;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ExtImmE <= 32'd0;
        RD1E <= 32'd0;
        RD2E <= 32'd0;
        WA3E <= 4'd0;
        PCSrcE <= 0;
        RegWriteE <= 0;
        MemToRegE <= 0;
        MemWriteE <= 0;
        ALUControlE <= 3'd0;
        BranchE <= 0;
        ALUSrcE <= 0;
        FlagWriteE <= 2'd0;
        FlagsE <= 4'b0000;
        CondE <= 0;
    end else begin
        ExtImmE <= ExtImmD;
        RD1E <= RD1D;
        RD2E <= RD2D;
        WA3E <= WA3D;
        PCSrcE <= PCSrcD;
        RegWriteE <= RegWriteD;
        MemToRegE <= MemToRegD;
        MemWriteE <= MemWriteD;
        ALUControlE <= ALUControlD;
        BranchE <= BranchD;
        ALUSrcE <= ALUSrcD;
        FlagWriteE <= FlagWriteD;
        FlagsE <= Flags;
        CondE <= CondD;
    end
end

endmodule

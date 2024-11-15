`timescale 1ns / 1ps

module decode_execute (
    clk,
    reset,
    PCPlus8D,
    ExtImm,
    RD1,
    RD2,
    WA3D,
    RegWriteD,
    MemToRegD,
    MemWriteD,
    PCPlus8E,
    ExtImmE,
    RD1E,
    RD2E,
    WA3E,
    RegWriteE,
    MemToRegE,
    MemWriteE
);

input wire clk;
input wire reset;
input wire [31:0] PCPlus8D;
input wire [31:0] ExtImm;
input wire [31:0] RD1;
input wire [31:0] RD2;
input wire [3:0] WA3D;
input wire RegWriteD;
input wire MemToRegD;
input wire MemWriteD;
output reg [31:0] PCPlus8E;
output reg [31:0] ExtImmE;
output reg [31:0] RD1E;
output reg [31:0] RD2E;
output reg [3:0] WA3E;
output reg RegWriteE;
output reg MemToRegE;
output reg MemWriteE;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        PCPlus8E <= 0;
        ExtImmE <= 0;
        RD1E <= 0;
        RD2E <= 0;
        WA3E <= 0;
        RegWriteE <= 0;
        MemToRegE <= 0;
        MemWriteE <= 0;
    end else begin
        PCPlus8E <= PCPlus8D;
        ExtImmE <= ExtImm;
        RD1E <= RD1;
        RD2E <= RD2;
        WA3E <= WA3D;
        RegWriteE <= RegWriteD;
        MemToRegE <= MemToRegD;
        MemWriteE <= MemWriteD;
    end
end

endmodule

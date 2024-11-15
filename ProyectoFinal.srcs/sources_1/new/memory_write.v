`timescale 1ns / 1ps

module memory_write(
    clk,
    reset,
    ALUOutM,
    RD,
    WA3M,
    RegWriteM,
    MemToRegM,
    ALUOutW,
    ReadDataW,
    WA3W,
    RegWriteW,
    MemToRegW
);

input wire clk;
input wire reset;
input wire [31:0] ALUOutM;
input wire [31:0] RD;
input wire [3:0] WA3M;
input wire RegWriteM;
input wire MemToRegM;
output reg [31:0] ALUOutW;
output reg [31:0] ReadDataW;
output reg [3:0] WA3W;
output reg RegWriteW;
output reg MemToRegW;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ALUOutW <= 0;
        ReadDataW <= 0;
        WA3W <= 0;
        RegWriteW <= 0;
        MemToRegW <= 0;
    end else begin
        ALUOutW <= ALUOutM;
        ReadDataW <= RD;
        WA3W <= WA3M;
        RegWriteW <= RegWriteM;
        MemToRegW <= MemToRegM;
    end
end

endmodule

`timescale 1ns / 1ps

module memory_write(
    clk, 
    reset, 
    ReadDataM,
    ALUOutM,
    WA3M,
    PCSrcM,
    RegWriteM, 
    MemToRegM,
    ReadDataW,
    ALUOutW,
    WA3W,
    PCSrcW,
    RegWriteW,
    MemToRegW
);

input wire clk;
input wire reset;

// EXECUTE STAGE
// datapath signals
input wire [31:0] ReadDataM;
input wire [31:0] ALUOutM;
input wire [3:0] WA3M;
// control signals
input wire PCSrcM;
input wire RegWriteM;
input wire MemToRegM;

// MEMORY STAGE
//datapath signals
output reg PCSrcW;
output reg RegWriteW;
output reg MemToRegW;
// control signals
output reg [31:0] ReadDataW;
output reg [31:0] ALUOutW;
output reg [3:0] WA3W;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // control signals
        PCSrcW <= 0;
        RegWriteW <= 0;
        MemToRegW <= 0;
        // datapath signals
        ALUOutW <= 0;
        ReadDataW <= 0;
        WA3W <= 4'd0;
    end else begin
        // control signals
        PCSrcW <= PCSrcM;
        RegWriteW <= RegWriteM;
        MemToRegW <= MemToRegM;
        // datapath signals
        ALUOutW <= ALUOutM;
        ReadDataW <= ReadDataM;
        WA3W <= WA3M;
    end
end

endmodule

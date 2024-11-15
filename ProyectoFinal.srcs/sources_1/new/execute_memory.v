`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2024 06:44:19 PM
// Design Name: 
// Module Name: execute_memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module execute_memory (
    clk,
    reset,
    ALUResultE,
    WriteDataE,
    WA3E,
    RegWriteE,
    MemToRegE,
    MemWriteE,
    ALUOutM,
    WriteDataM,
    WA3M,
    RegWriteM,
    MemToRegM,
    MemWriteM
);

input wire clk;
input wire reset;
input wire [31:0] ALUResultE;
input wire [31:0] WriteDataE;
input wire [3:0] WA3E;
input wire RegWriteE;
input wire MemToRegE;
input wire MemWriteE;
output reg [31:0] ALUOutM;
output reg [31:0] WriteDataM;
output reg [3:0] WA3M;
output reg RegWriteM;
output reg MemToRegM;
output reg MemWriteM;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ALUOutM <= 0;
        WriteDataM <= 0;
        WA3M <= 0;
        RegWriteM <= 0;
        MemToRegM <= 0;
        MemWriteM <= 0;
    end else begin
        ALUOutM <= ALUResultE;
        WriteDataM <= WriteDataE;
        WA3M <= WA3E;
        RegWriteM <= RegWriteE;
        MemToRegM <= MemToRegE;
        MemWriteM <= MemWriteE;
    end
end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2024 05:34:44 PM
// Design Name: 
// Module Name: memory_stg
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


module memory_stg(
    clk,
    reset, 
    MemWriteM,
    ALUResultE, 
    WriteDataE, 
    WA3E, 
    ALUOutM, 
    WA3M, 
    RD
    );
    
input wire clk;
input wire reset;
input wire MemWriteM;
input wire [31:0] ALUResultE;
input wire [31:0] WriteDataE;
input wire [3:0] WA3E;
output wire [31:0] ALUOutM;
output wire [3:0] WA3M;    
output wire [31:0] RD;
    
dmem dtmem(
    .clk(clk),
    .we(MemWriteM),
    .a(A),
    .wd(WD),
    .rd(RD)
);

assign ALUOutM = ALUResultE;
assign WA3M = WA3E;

endmodule

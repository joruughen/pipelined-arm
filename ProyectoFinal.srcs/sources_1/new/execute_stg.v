`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2024 05:16:06 PM
// Design Name: 
// Module Name: execute_stg
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


module execute_stg(
    SrcAE, 
    WriteData, 
    ExtImmE, 
    ALUSrcE,
    ALUControlE, 
    ALUFlags, 
    WA3,
    WA3E, 
    WriteDataE, 
    ALUResultE
    );

input wire [31:0] SrcAE;
input wire [31:0] WriteData;
input wire [31:0] ExtImmE;
input wire ALUSrcE;
input wire [2:0] ALUControlE;
input wire [3:0] ALUFlags;
input wire [3:0] WA3;
output wire [3:0] WA3E;
output wire [3:0] WriteDataE;
output wire ALUResultE;

wire [31:0] SrcBE;

mux2 #(32) srcb(
    .d0(WriteData),
    .d1(ExtImmE),
    .s(ALUSrcE),
    .y(SrcBE)
);

alu alub(
    .a(SrcAE),
    .b(ALUSrcE),
    .ALUControl(ALUControlE),
    .Result(ALUResultE),
    .ALUFlags(ALUFlags)
);

assign WriteDataE = WriteData;
assign WA3E = WA3;
    
endmodule

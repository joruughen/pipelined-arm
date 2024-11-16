`timescale 1ns / 1ps

module execute_stg(
    RD1E, 
    RD2E, 
    ExtImmE, 
    ALUSrcE,
    ALUControlE, 
    ALUFlags,
    ALUResultE,
    WriteDataE
);

input wire [31:0] RD1E;
input wire [31:0] RD2E;
input wire [31:0] ExtImmE;
input wire ALUSrcE;
input wire [2:0] ALUControlE;
output wire [3:0] ALUFlags;
output wire [31:0] ALUResultE;
output wire [31:0] WriteDataE;

wire [31:0] SrcBE;

mux2 #(32) srcb(
    .d0(RD2E),
    .d1(ExtImmE),
    .s(ALUSrcE),
    .y(SrcBE)
);

alu alub(
    .a(RD1E),
    .b(SrcBE),
    .ALUControl(ALUControlE),
    .Result(ALUResultE),
    .ALUFlags(ALUFlags)
);

assign WriteDataE = RD2E;
    
endmodule

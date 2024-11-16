`timescale 1ns / 1ps

module memory_stg(
    clk,
    reset, 
    MemWriteM,
    ALUResultM, 
    WriteDataM, 
    ALUOutM, 
    ReadDataM
    );
    
input wire clk;
input wire reset;
input wire MemWriteM;
input wire [31:0] ALUResultM;
input wire [31:0] WriteDataM;
output wire [31:0] ALUOutM;
output wire [31:0] ReadDataM;
    
dmem dtmem(
    .clk(clk),
    .we(MemWriteM),
    .a(ALUResultM),
    .wd(WriteDataM),
    .rd(ReadDataM)
);

assign ALUOutM = ALUResultM;

endmodule

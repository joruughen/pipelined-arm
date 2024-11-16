`timescale 1ns / 1ps

module write_stg(
    MemToRegW,
    ALUOutW, 
    ReadDataW,
    ResultW
    );
    
input wire MemToRegW;
input wire [31:0] ReadDataW;
input wire [31:0] ALUOutW;
output wire [31:0] ResultW;

mux2 #(32) resmux(
    .d0(ReadDataW),
    .d1(ALUOutW),
    .s(MemToRegW),
    .y(ResultW)
);

endmodule

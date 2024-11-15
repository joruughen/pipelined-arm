`timescale 1ns / 1ps

module write_stg(
    MemToRegW,
    ALUOutW, 
    ReadDataW,
    WA3M,
    WA3W,
    ResultW
    );
    
input wire MemToRegW;
input wire ReadDataW;
input wire ALUOutW;
input wire WA3M;
input wire WA3W;
output wire [31:0] ResultW;

mux2 #(32) resmux(
    .d0(ReadDataW),
    .d1(ALUOutW),
    .s(MemToRegW),
    .y(ResultW)
);

assign WA3W = WA3M;

endmodule

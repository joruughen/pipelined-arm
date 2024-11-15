`timescale 1ns / 1ps

module decode_stg(
    clk, 
    reset,
    InstrD, 
    Flags,
    RegSrcD, 
    ImmSrcD,
    PCPlus8D,
    ResultW,
    WA3W,
    ExtImm,
    RD1, 
    RD2
    );
    
input wire clk;
input wire reset;
input wire [31:0] InstrD;
input wire Flags;
input wire [1:0] RegSrcD; // Cambiado a vector de 2 bits
input wire ImmSrcD;
input wire [31:0] PCPlus8D;
input wire [31:0] ResultW;
input wire [3:0] WA3W;
output wire [31:0] ExtImm;
output wire [31:0] RD1;
output wire [31:0] RD2;
    
wire [3:0] RA1D; // Cambiado a 4 bits para adaptarse a RA1D
wire [3:0] RA2D;
    
mux2 #(4) ra1Dmux (
    .d0(InstrD[19:16]),
    .d1(4'd15),
    .s(RegSrcD[0]),    
    .y(RA1D)
);  

mux2 #(4) ra2Dmux (
    .d0(InstrD[3:0]),
    .d1(InstrD[15:12]),
    .s(RegSrcD[1]),    
    .y(RA2D)
);

regfile rfile(
    .clk(~clk),
    .we3(Flags),
    .ra1(RA1D),
    .ra2(RA2D),
    .wa3(WA3W),
    .wd3(ResultW),
    .r15(PCPlus8D),
    .rd1(RD1),
    .rd2(RD2) 
);

extend ext(
    .Instr(InstrD[22:0]),
    .ImmSrc(ImmSrcD),
    .ExtImm(ExtImm)
);
    
endmodule

`timescale 1ns / 1ps

module decode_stg(
    clk, 
    reset,
    InstrD, 
    RegWriteW,
    RegSrcD, 
    ImmSrcD,
    PCPlus8D,
    ResultW,
    WA3D,
    WA3W,
    ExtImmD,
    RD1D, 
    RD2D
    );
    
input wire clk;
input wire reset;

input wire [31:0] InstrD;
input wire RegWriteW;
input wire [1:0] RegSrcD; 
input wire [1:0] ImmSrcD;
input wire [31:0] PCPlus8D;
input wire [31:0] ResultW;
input wire [3:0] WA3W;

output wire [3:0] WA3D;
output wire [31:0] ExtImmD;
output wire [31:0] RD1D;
output wire [31:0] RD2D;
    
wire [3:0] RA1D; 
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
    .we3(RegWriteW),
    .ra1(RA1D),
    .ra2(RA2D),
    .wa3(WA3W),
    .wd3(ResultW),
    .r15(PCPlus8D),
    .rd1(RD1D),
    .rd2(RD2D) 
);

extend extimm(
    .Instr(InstrD[23:0]),
    .ImmSrc(ImmSrcD),
    .ExtImm(ExtImmD)
);

assign WA3D = InstrD[15:12];
    
endmodule

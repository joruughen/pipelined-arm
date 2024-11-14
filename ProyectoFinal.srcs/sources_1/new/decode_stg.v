`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2024 04:50:01 PM
// Design Name: 
// Module Name: decode_stg
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
input wire RegSrcD;
input wire ImmSrcD;
input wire [31:0] PCPlus8D;
input wire [31:0] ResultW;
input wire [3:0] WA3W;
output wire [31:0] ExtImm;
output wire [31:0] RD1;
output wire [31:0] RD2;
    
wire RA1D;
wire RA2D;
    
mux2 ra1Dmux(
    .d0(InstrD[19:16]),
    .d1(32'd15),
    .s(RegSrcD),    
    .y(RA1D)
);  
    
mux2 ra2Dmux(
    .d0(InstrD[3:0]),
    .d1(InstrD[15:12]),
    .s(RegSrcD),    
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
    .rd1(RD2) 
);

extend ext(
    .Instr(InstrD[22:0]),
    .ImmSrc(ImmSrcD),
    .ExtImm(ExtImm)
);
    
endmodule

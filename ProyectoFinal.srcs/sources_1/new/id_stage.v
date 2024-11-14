module id_stage (
    input wire clk,
    input wire reset,
    input wire [31:0] Instr,
    input wire [1:0] RegSrc,
    input wire RegWrite,
    input wire [1:0] ImmSrc,
    input wire [31:0] MEM_WB_data,
    input wire [31:0] r15,
    output wire [31:0] A,
    output wire [31:0] B,
    output wire [31:0] imm
);
    // Banco de registros
    regfile rf_inst (
        .clk(clk),
        .we3(RegWrite),
        .ra1(Instr[19:16]),
        .ra2(Instr[3:0]),
        .wa3(Instr[15:12]),
        .wd3(MEM_WB_data),
        .r15(r15),
        .rd1(A),
        .rd2(B)
    );

    // Extensor de señales
    extend extend_inst (
        .Instr(Instr[23:0]),
        .ImmSrc(ImmSrc),
        .ExtImm(imm)
    );
endmodule

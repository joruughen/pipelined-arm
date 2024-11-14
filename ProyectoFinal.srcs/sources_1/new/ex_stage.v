module ex_stage (
    input wire clk,
    input wire reset,
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [31:0] imm,
    input wire ALUSrc,
    input wire [1:0] ALUControl,
    output wire [31:0] ALU_out,
    output wire [3:0] ALUFlags
);
    wire [31:0] ALU_inputB;

    // Selección de fuente para la ALU
    assign ALU_inputB = (ALUSrc) ? imm : B;

    // ALU
    alu alu_inst (
        .a(A),
        .b(ALU_inputB),
        .alu_control(ALUControl),
        .result(ALU_out),
        .flags(ALUFlags)
    );
endmodule

module if_stage (
    input wire clk,
    input wire reset,
    input wire PCSrc,
    input wire [31:0] ALUResult,
    output wire [31:0] PC,
    output wire [31:0] PCPlus4
);
    wire [31:0] PCNext;

    // Mux para seleccionar la próxima dirección del PC
    mux2 #(.WIDTH(32)) pcmux_inst (
        .d0(PCPlus4),
        .d1(ALUResult),
        .s(PCSrc),
        .y(PCNext)
    );

    // Registro de PC
    flopr #(.WIDTH(32)) pcreg_inst (
        .clk(clk),
        .reset(reset),
        .d(PCNext),
        .q(PC)
    );

    // Sumador para calcular PC + 4
    adder #(.WIDTH(32)) pcadd1_inst (
        .a(PC),
        .b(32'b100),
        .y(PCPlus4)
    );
endmodule

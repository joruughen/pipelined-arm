module datapath (
    input wire clk,
    input wire reset,
    input wire [1:0] RegSrc,
    input wire RegWrite,
    input wire [1:0] ImmSrc,
    input wire ALUSrc,
    input wire [1:0] ALUControl,
    input wire MemtoReg,
    input wire PCSrc,
    output wire [3:0] ALUFlags,
    output wire [31:0] PC,
    input wire [31:0] Instr,
    output wire [31:0] ALUResult,
    output wire [31:0] WriteData,
    input wire [31:0] ReadData
);

    // Intermediate pipeline registers
    reg [31:0] IF_ID_instr, IF_ID_PC;
    reg [31:0] ID_EX_A, ID_EX_B, ID_EX_imm, ID_EX_PC;
    reg [31:0] EX_MEM_ALUResult, EX_MEM_B;
    reg [31:0] MEM_WB_data;

    // IF Stage - Instancia del módulo if_stage
    wire [31:0] PCNext, PCPlus4;
    wire [31:0] IF_instr;
    if_stage if_stage_inst (
        .clk(clk),
        .reset(reset),
        .PCSrc(PCSrc),
        .PCNext(PCNext),
        .Instr(Instr),
        .PC(PC),
        .PCPlus4(PCPlus4)
    );

    always @(posedge clk) begin
        if (reset) begin
            IF_ID_instr <= 0;
            IF_ID_PC <= 0;
        end else begin
            IF_ID_instr <= Instr;
            IF_ID_PC <= PC;
        end
    end

    // ID Stage - Instancia del módulo id_stage
    wire [31:0] A, B, imm;
    id_stage id_stage_inst (
        .clk(clk),
        .reset(reset),
        .Instr(IF_ID_instr),
        .RegWrite(RegWrite),
        .RegSrc(RegSrc),
        .ImmSrc(ImmSrc),
        .MEM_WB_data(MEM_WB_data),
        .A(A),
        .B(B),
        .imm(imm)
    );

    always @(posedge clk) begin
        if (reset) begin
            ID_EX_A <= 0;
            ID_EX_B <= 0;
            ID_EX_imm <= 0;
            ID_EX_PC <= 0;
        end else begin
            ID_EX_A <= A;
            ID_EX_B <= B;
            ID_EX_imm <= imm;
            ID_EX_PC <= IF_ID_PC;
        end
    end

    // EX Stage - Instancia del módulo ex_stage
    wire [31:0] ALU_out;
    ex_stage ex_stage_inst (
        .clk(clk),
        .reset(reset),
        .A(ID_EX_A),
        .B(ID_EX_B),
        .imm(ID_EX_imm),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl),
        .ALU_out(ALU_out),
        .ALUFlags(ALUFlags)
    );

    always @(posedge clk) begin
        if (reset) begin
            EX_MEM_ALUResult <= 0;
            EX_MEM_B <= 0;
        end else begin
            EX_MEM_ALUResult <= ALU_out;
            EX_MEM_B <= ID_EX_B;
        end
    end

    // MEM Stage - Instancia del módulo mem_stage
    mem_stage mem_stage_inst (
        .clk(clk),
        .reset(reset),
        .ALUResult(EX_MEM_ALUResult),
        .B(EX_MEM_B),
        .MemtoReg(MemtoReg),
        .ReadData(ReadData),
        .WriteData(WriteData),
        .MEM_WB_data(MEM_WB_data)
    );

    // WB Stage - Instancia del módulo wb_stage
    wb_stage wb_stage_inst (
        .clk(clk),
        .reset(reset),
        .MEM_WB_data(MEM_WB_data),
        .ALUResult(EX_MEM_ALUResult),
        .ALU_out(ALUResult)
    );

endmodule

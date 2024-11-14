module mem_stage (
    input wire clk,
    input wire reset,
    input wire [31:0] ALUResult,
    input wire [31:0] B,
    input wire MemtoReg,
    input wire [31:0] ReadData,
    output wire [31:0] WriteData,
    output wire [31:0] MEM_WB_data
);
    // Asignación de datos para escritura
    assign WriteData = B;

    // Selección de datos para escribir en el siguiente registro intermedio
    assign MEM_WB_data = (MemtoReg) ? ReadData : ALUResult;
endmodule

module wb_stage (
    input wire clk,
    input wire reset,
    input wire [31:0] MEM_WB_data,
    input wire [31:0] ALUResult,
    output wire [31:0] ALU_out
);
    // Pasar el resultado de la ALU o el valor de memoria al banco de registros
    assign ALU_out = MEM_WB_data;
endmodule

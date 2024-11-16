`timescale 1ns / 1ps

module execute_memory (
    clk, 
    reset, 
    PCSrcE,
    RegWriteE, 
    MemToRegE,
    MemWriteE,
    ALUResultE, 
    WriteDataE, 
    WA3E, 
    PCSrcM,
    RegWriteM, 
    MemToRegM, 
    MemWriteM, 
    ALUResultM,
    WriteDataM, 
    WA3M
);

input wire clk;
input wire reset;
    
// EXECUTE STAGE
// control signals
input wire PCSrcE;
input wire RegWriteE;
input wire MemToRegE;
input wire MemWriteE;
// datapath signals
input wire [31:0] ALUResultE;
input wire [31:0] WriteDataE;  
input wire [3:0] WA3E; 

// MEMORY STAGE
// control signals
output reg PCSrcM;
output reg RegWriteM;
output reg MemToRegM;
output reg MemWriteM;
// datapath signals
output reg [31:0] ALUResultM;
output reg [31:0] WriteDataM;
output reg [3:0] WA3M;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // control signals
        PCSrcM <= 0;
        RegWriteM <= 0;
        MemToRegM <= 0;
        MemWriteM <= 0;
        // datapath signals
        ALUResultM <= 32'd0;
        WriteDataM <= 32'd0;
        WA3M <= 4'd0;
    end else begin
        // control signals
        PCSrcM <= PCSrcE;
        RegWriteM <= RegWriteE;
        MemToRegM <= MemToRegE;
        MemWriteM <= MemWriteE;
        // datapath signals
        ALUResultM <= ALUResultE;
        WriteDataM <= WriteDataE;
        WA3M <= WA3E;
    end
end

endmodule
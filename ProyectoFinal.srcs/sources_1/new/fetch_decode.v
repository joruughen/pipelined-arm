`timescale 1ns / 1ps

module fetch_decode (
    clk,
    reset,
    InstrF,
    InstrD
);

input wire clk;
input wire reset;

// FECTH STAGE
input wire [31:0] InstrF;

// DECODE STAGE
output reg [31:0] InstrD;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        InstrD <= 32'd0;
    end else begin
        InstrD <= InstrF;
    end
end

endmodule
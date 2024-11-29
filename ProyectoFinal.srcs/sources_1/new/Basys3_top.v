module Basys3_top(
    input clk,                // Reloj del Basys3
    input reset,              // Botón de reset
    input  in,           // Entrada de 4 bits (puedes mapearla a switches del Basys3)
    input [3:0] enable,       // Habilitación de 4 bits (puedes mapearla a switches del Basys3)
    output [27:0] out,         // Salida de 7 bits (puedes mapearla a un display de 7 segmentos)
    output [31:0] WriteData,  // Señales de depuración o LEDs
    output [31:0] DataAdr,
    output MemWrite,
    output [31:0] PC
);
    wire slow_clk;

    // Instancia de clk_divider
    clk_divider clk_div(
        .clk(clk),
        .rst(reset),
        .led(slow_clk)
    );

    // Instancia de top
    
    top dut(
        .clk(slow_clk),    
        .reset(reset),
        .WriteData(WriteData),
        .DataAdr(DataAdr),
        .MemWrite(MemWrite),
        .PC(PC)
    );
    

    // Instancia de decoder
    decoder dec(
        .in(in),
        .PC(PC),
        .enable(enable),
        .out(out)
    );

endmodule

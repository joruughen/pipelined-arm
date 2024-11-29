`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Gabriele Felaco
// 
// Create Date: 02.09.2020 01:16:07
// Design Name: 
// Module Name: decoder
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


module decoder(
    output reg [27:0] out,  // Ahora es de 24 bits
    output reg [3:0] enable, // Controla cuál de los 4 segmentos está activo
    input in,               // Si está prendido, activamos la lógica de PC
    input [3:0] PC          // Los 4 bits de PC que determinan qué se mostrará
    );

    // Declaración de las combinaciones de segmentos de 7 bits
    wire [6:0] segs [0:15]; // 16 posibles combinaciones para los 4 bits de PC

    // Asignación de los valores para cada 4 bits de PC
    assign segs[4'b0000] = 7'b0000001; // Display 0
    assign segs[4'b0001] = 7'b1001111; // Display 1
    assign segs[4'b0010] = 7'b0010010; // Display 2
    assign segs[4'b0011] = 7'b0000110; // Display 3
    assign segs[4'b0100] = 7'b1001100; // Display 4
    assign segs[4'b0101] = 7'b0100100; // Display 5
    assign segs[4'b0110] = 7'b0100000; // Display 6
    assign segs[4'b0111] = 7'b0001111; // Display 7
    assign segs[4'b1000] = 7'b0000000; // Display 8
    assign segs[4'b1001] = 7'b0001100; // Display 9
    assign segs[4'b1010] = 7'b0001000; // Display A
    assign segs[4'b1011] = 7'b1100000; // Display b
    assign segs[4'b1100] = 7'b0110001; // Display C
    assign segs[4'b1101] = 7'b1000010; // Display d
    assign segs[4'b1110] = 7'b0110000; // Display E
    assign segs[4'b1111] = 7'b0111000; // Display F

    always @(in or PC) begin
        if (in) begin
            // Si 'in' está prendido, decodificamos el valor de 'PC' en los 4 segmentos de 7 bits
            out[6:0]   = segs[PC];    // Primer segmento de 7 bits (primer parte de 'PC')
            out[13:7]  = segs[PC];    // Segundo segmento de 7 bits
            out[20:14] = segs[PC];    // Tercer segmento de 7 bits
            out[27:21] = segs[PC];    // Cuarto segmento de 7 bits

            // Lógica para habilitar un solo segmento (AN0 a AN3), en este caso AN0 siempre está activado
            enable = 4'b0000;  // Activo los display AN0, AN1,An2,An3
        end
        else begin
            // Si 'in' no está prendido, no se activa nada
            out = 24'b000000000000000000000000; // Apaga todos los segmentos
            enable = 4'b1111;  // Desactiva todos los segmentos
        end
    end
endmodule

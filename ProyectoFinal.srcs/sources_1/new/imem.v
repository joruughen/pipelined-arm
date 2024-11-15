`timescale 1ns / 1ps

module imem (
    input wire [31:0] a,
    output wire [31:0] rd
);
    reg [31:0] RAM [0:255]; // Adjust size as needed

    initial begin
        $readmemh("memfile_example.mem", RAM);
    end

    assign rd = RAM[a[31:2]]; // Adjust addressing as needed
endmodule
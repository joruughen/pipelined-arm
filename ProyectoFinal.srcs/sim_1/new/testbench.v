module testbench();
    reg clk;                // Reloj simulado
    reg reset;              // Reset simulado
    reg  switches;     // Switches simulados (equivalente a 'in')
    reg [3:0] enable_switches; // Enable simulados (equivalente a 'enable')
    wire [27:0] out;         // Salida conectada al display de 7 segmentos
    wire [31:0] WriteData;  // Señal simulada para WriteData
    wire [31:0] DataAdr;    // Señal simulada para DataAdr
    wire MemWrite;          // Señal simulada para MemWrite
    wire [31:0] PC;         // Señal simulada para PC
    reg slow_clk;          // Reloj dividido


    // Instancia del módulo 'top'
    Basys3_top dut(
        .clk(slow_clk),    // Conecta el reloj dividido
        .reset(reset),     // Reset
        .in(switches),
        .enable(enable_switches),
        .out(out),
        .WriteData(WriteData),
        .DataAdr(DataAdr),
        .MemWrite(MemWrite),
        .PC(PC)
    );

    
    initial begin
        slow_clk = 0;
        forever #5 slow_clk = ~slow_clk; // Reloj con período de 10 unidades de tiempo
    end

    // Inicialización de señales
    initial begin
        reset = 1;               // Activar reset
        switches = 1;

        #20 reset = 0;           // Desactivar reset

        // Cambios en las entradas
        
        #30 switches = 0;
       

        #100 $finish; // Terminar la simulación
    end
endmodule

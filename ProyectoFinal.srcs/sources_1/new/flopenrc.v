module flopenrc (
    clk,
    reset,
    en,
    clear,
    d,
    q
);
    parameter WIDTH = 8;
    input wire clk, reset, en, clear;
    input wire [WIDTH-1:0] d;
    output reg [WIDTH-1:0] q; 

    always @(posedge clk, posedge reset) begin
        if (reset)
            q <= 0;
        else if (en) begin
            if (clear)
                q <= 0;
            else
                q <= d;
        end
    end
endmodule
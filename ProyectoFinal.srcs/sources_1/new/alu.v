module alu(input [31:0] a, b, input [2:0] ALUControl,
    output reg [31:0] Result, output wire [3:0] ALUFlags,
    input N, input NoW, input Long, input Signed, input Carry, input Inv, input [3:0] FlagsPrima);
    
    wire neg, zero, carry, overflow;
    reg [32:0] sum;
    
    
    always @(*)
        begin
            casex (ALUControl[2:0])
            3'b000: begin
                if (Carry) begin
                    sum = a + b + FlagsPrima[1];
                end
                else sum = a + b;
            end
            3'b001: begin
                if (Carry) sum = a - b - FlagsPrima[1];
                else if (Inv) sum = b - a;
                else sum = a - b;
            end
            3'b010: begin
                if (N) sum = a & ~b;
                else sum = a & b;
            end
            3'b011: begin
                if (N) sum = a | ~b;
                else sum = a | b;
            end
            3'b100: sum = a ^ b;
            endcase
        Result = sum[31:0];
    end
    
    assign neg = Result[31];
    assign zero = (Result == 32'b0);
    assign carry = sum[32];
    assign overflow = (ALUControl[2:1] == 2'b00) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);
    assign ALUFlags = {neg, zero, carry, overflow};
    

endmodule

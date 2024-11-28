module alu(input [31:0] a, b, input [2:0] ALUControl,
    output reg [31:0] Result, output wire [3:0] ALUFlags,
    input N, input NoW, input Long, input Signed, input Carry, input Inv, input [3:0] FlagsPrima);
    
    wire neg, zero, carry, overflow;
    wire [31:0] condinvb;
    wire [32:0] sum;
    
    
    // assign condinvb = ALUControl[0] ? ~b : b;
    // assign sum = a + condinvb + ALUControl[0];
    always @(*)
        begin
            casex (ALUControl[2:0])
            3'b000: begin
                if (Carry) Result = a + b + FlagsPrima[1];
                else Result = a + b;
            end
            3'b001: Result = a - b;
            3'b010: begin
                if (N) Result = a & ~b;
                else Result = a & b;
            end
            3'b011: Result = a | b;
            3'b100: Result = a ^ b;
            endcase
    end
    
    assign neg = Result[31];
    assign zero = (Result == 32'b0);
    assign carry = (ALUControl[1] ==
    1'b0)
    & sum[32];
    assign overflow = (ALUControl[1] ==
    1'b0)
    & ~(a[31] ^ b[31] ^
    ALUControl[0]) &
    (a[31]
    ^ sum[31]);
    assign ALUFlags = {neg, zero, carry,
    overflow};
    

endmodule

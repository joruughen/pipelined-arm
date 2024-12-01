module alu(input [31:0] a, b, c, d, input [2:0] ALUControl,
    output reg [31:0] ResultA, ResultB, output wire [3:0] ALUFlags,
    input N, input NoW, input Long, input Signed, input Carry, input Inv, input [3:0] FlagsPrima);
    
    wire neg, zero, carry, overflow;
    reg [64:0] sum;
    
    reg [63:0] prod;
    wire [63:0] sumacc;
    
    assign sumacc = {d, c};

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
            3'b101: begin
                if (Signed & Long) begin
                    prod = $signed(a) * $signed(b);
                // smull
                end
                else if (Long) begin
                // umull
                    prod = a * b;
                end
                else begin
                // mul
                    sum = a * b;
                end  
            end
            3'b110: begin
                if (Signed & Long) begin
                // smlal
                    prod = $signed(a) * $signed(b);
                    sum = prod + sumacc;
                end
                else if (Long) begin
                // umlal
                    prod = a * b;
                    sum = prod + sumacc;
                end
                else if (N) begin
                    prod = a * b;
                    sum = c - prod; 
                // mls
                end
                else begin
                // mla
                    prod = a * b;
                    sum = prod + c;
                end
            end
            endcase
        ResultA = sum[31:0];
        if (Long) begin
            ResultB = sum[63:0];
        end
    end
    
    assign neg = ResultA[31];
    assign zero = (ResultA == 32'b0);
    assign carry = sum[32];
    assign overflow = (ALUControl[2:1] == 2'b00) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);
    assign ALUFlags = {neg, zero, carry, overflow};
    

endmodule

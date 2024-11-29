module decode (
	Op,
	Funct,
	Rd,
	FlagW,
	PCS,
	RegW,
	MemW,
	MemtoReg,
	ALUSrc,
	ImmSrc,
	RegSrc,
	ALUControl,
	Branch,
	Shift,
	N,
	NoW, 
	Long,
	Signed,
	Carry, 
	Inv
);
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	output reg [1:0] FlagW;
	output wire PCS;
	output wire [1:0] RegW;
	output wire MemW;
	output wire MemtoReg;
	output wire ALUSrc;
	output wire [1:0] ImmSrc;
	output wire [5:0] RegSrc;
	output wire Shift;
	output reg [2:0] ALUControl;
	output wire N, NoW, Long, Signed, Carry, Inv;
	reg [15:0] controls;
	reg [5:0] alucontrols;
	output wire Branch;
	wire [1:0] ALUOp;
	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
					controls = 17'b00xxx0_00_1_0_01_0_0_01_0;
				else
					controls = 17'b000010_00_0_0_01_0_0_01_1;
			2'b01:
				if (Funct[0])
					controls = 17'b00xxxx_01_1_1_01_0_0_00_0;
				else
					controls = 17'b10xxxx_01_1_1_00_1_0_00_0;
			2'b10: controls = 17'b01xxxx_10_1_0_00_0_1_00_0;
			default: controls = 17'bxxxxxxxxxxxxx;
		endcase
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp, Shift} = controls;
	
	assign {N, NoW, Long, Signed, Carry, Inv} = alucontrols;
	
	always @(*) begin
	   alucontrols = 6'b000000;
		if (ALUOp == 2'b01) begin
			case (Funct[4:1])
				4'b0100: ALUControl = 3'b000; 
				4'b0010: ALUControl = 3'b001;
				4'b0000: ALUControl = 3'b010;
				4'b1100: ALUControl = 3'b011;
				4'b0001: ALUControl = 3'b100;
				4'b1110: begin
				    ALUControl = 3'b010;
				    alucontrols = 6'b100000;
				    end
				4'b1101: begin
				    ALUControl = 3'b011;
				    alucontrols = 6'b100000;
				    end
				4'b0101: begin
				    ALUControl = 3'b000;
				    alucontrols = 6'b000010;
				    end
				4'b0110: begin
				    ALUControl = 3'b001;
				    alucontrols = 6'b000010;
				    end
				4'b0011: begin 
				    ALUControl = 3'b001;
				    alucontrols = 6'b000001;
				end
				4'b1010: begin 
				    ALUControl = 3'b001;
				    alucontrols = 6'b010000;
				end
				4'b1011: begin
				    ALUControl = 3'b000;
				    alucontrols = 6'b010000;
				end
				4'b1000: begin
				    ALUControl = 3'b010;
				alucontrols = 6'b010000;
				end
				4'b1001: begin 
				    ALUControl = 3'b100;
			        alucontrols = 6'b010000;
			    end
				default: ALUControl = 3'bxxx;
			endcase
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0];
		end
		else begin
			ALUControl = 3'b000;
			FlagW = 2'b00;
		end
		end
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule
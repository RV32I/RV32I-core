module control_unit 
#(
	parameter width = 32
)
(
    input   [width-1:0] opcode,
    input   [6:0]       funct7,
    input   [2:0]       funct3,

    output reg          RegWrite,
    output reg          MemtoReg,
    output reg          MemWrite,
    output reg          ALUSrc,
    output reg [2:0]    ALUOp,
    output reg [2:0]    MemOp,
    output reg          Branch,
    output reg          Jump,
    output reg          JumpAndLink,
    output reg [1:0]    PCSrc
);

always @(*)
begin
    case(opcode)
        7'b0110011 : begin
            RegWrite    = 1;
            MemtoReg    = 0;
            MemWrite    = 0;
            ALUSrc      = 0;
            ALUOp       = 0;
            MemOp       = 1;
            Branch      = 0;
            Jump        = 0;
            JumpAndLink = 0;
            PCSrc       = 0;
        end
        7'b0010011 : begin
            RegWrite    = 1;
            MemtoReg    = 0;
            MemWrite    = 0;
            ALUSrc      = 1;
            ALUOp       = 0
            MemOp       = 0;
            Branch      = 0;
            Jump        = 0;
            JumpAndLink = 0;
            PCSrc       = 0;
        end
        7'b0000011 : begin
            RegWrite    = 1;
            MemtoReg    = 1;
            MemWrite    = 0;
            ALUSrc      = 1;
            ALUOp       = 0; 
            MemOp       = 0;
            Branch      = 0;
            Jump        = 0;
            JumpAndLink = 0;
            PCSrc       = 0;
        end
        7'b0100011 : begin
            RegWrite    = 0;
            MemtoReg    = 0;
            MemWrite    = 1;
            ALUSrc      = 1;
            ALUOp       = 0; 
            MemOp       = 0;
            Branch      = 0;
            Jump        = 0;
            JumpAndLink = 0;
            PCSrc       = 0;
        end
        7'b1100011 : begin
            RegWrite    = 0;
            MemtoReg    = 0;
            MemWrite    = 0;
            ALUSrc      = 0;
            ALUOp       = 1;
            MemOp       = 0;
            Branch      = 1;
            Jump        = 0;
            JumpAndLink = 0;
            PCSrc       = 1;
        end
        7'b1101111 : begin
            RegWrite    = 0;
            MemtoReg    = 0;
            MemWrite    = 0;
            ALUSrc      = 0;
            ALUOp       = 0; 
            MemOp       = 0;
            Branch      = 0;
            Jump        = 1;
            JumpAndLink = 1;
            PCSrc       = 2'b10;
        end
    endcase
end

endmodule




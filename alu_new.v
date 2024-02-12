//ALu
module ALu
#(
	parameter [WIDTH-1:0]   WIDTH   =32
)
(

	input 			      ALU_CONTROL,
	input   [WIDTH-1:0]   oprend_1,
	input   [WIDTH-1:0]   oprend_2,
	input   [WIDTH-1:0]   alu_out,
	output  [WIDTH-1:0]	  Alu_result,
	output  [WIDTH-1:0]	  branch_execution
); 

reg                     insrt;
reg   			        opcode;
wire  [14:12]           Func3;
wire  [31:25]           Func7;
wire  [WIDTH-1:0]    	ADD		=	4'b0000 ;
wire  [WIDTH-1:0]    	SUB		=	4'b0001 ;
wire  [WIDTH-1:0]    	SLL		=	4'b0010 ;
wire  [WIDTH-1:0]    	SLT		=	4'b0011 ;
wire  [WIDTH-1:0]       SLTU	=	4'b0100 ;
wire  [WIDTH-1:0]    	XOR		=	4'b0101 ;
wire  [WIDTH-1:0]    	SRL		=	4'b0110 ;
wire  [WIDTH-1:0]    	SRA		=	4'b0111 ;
wire  [WIDTH-1:0]    	OR		=	4'b1000 ;
wire  [WIDTH-1:0]    	AND		=	4'b1001 ;
wire  [WIDTH-1:0]    	BEQ		=	4'b1010 ; 
wire  [WIDTH-1:0]    	BNE		=	4'b1011 ; 
wire  [WIDTH-1:0]    	BLT		=	4'b1100 ;	
wire  [WIDTH-1:0]    	BGE		=	4'b1101 ; 
wire  [WIDTH-1:0]    	BLTU	=	4'b1110 ; 
wire  [WIDTH-1:0]    	BGEU	=	4'b1111 ;	


always@* opcode = insrt[6:0];
always@(*)
begin 
	case(ALU_CONTROL)
		ADD    : alu_out = oprend_1 +  oprend_2;
		SUB    : alu_out = oprend_1 -  oprend_2;
		SLL	   : alu_out = oprend_1 << oprend_2;
		SLT	   : alu_out = $signed (oprend_1) <  $signed (oprend_2);
		SLTU   : alu_out = oprend_1 <  oprend_2; 
		XOR    : alu_out = oprend_1 ^  oprend_2; 
		SRL    : alu_out = oprend_1 >> oprend_2;
		SRA    : alu_out = oprend_1 >>> oprend_2;
		OR     : alu_out = oprend_1 |  oprend_2;
		AND    : alu_out = oprend_1 &  oprend_2;
		BEQ    : alu_out = oprend_1 ==  oprend_2;
		BNE    : alu_out = oprend_1 <= oprend_2; 
		BLT    : alu_out = $signed (oprend_1) < $signed (oprend_2);
		BGE    : alu_out = $signed (oprend_1) >= $signed (oprend_2);
		BLTU   : alu_out = oprend_1 < oprend_2;
        BGEU   : alu_out = oprend_1 >= oprend_2; 
	endcase	
end



assign ALU_CONTROL =(Func3 == 3'b000) ? ADD :
					(Func3 == 3'b000) ? SUB :
					(Func3 == 3'b001) ? SLL :
					(Func3 == 3'b010) ? SLT :
					(Func3 == 3'b011) ? SLTU:
					(Func3 == 3'b100) ? XOR :
					(Func3 == 3'b101) ? SRL : 
					(Func3 == 3'b101) ? SRA :
					(Func3 == 3'b110) ? OR  :
					(Func3 == 3'b111) ? AND ; 
					
					
assign branch_execution =   (Func3 == 3'b000) ? BEQ  :
							(Func3 == 3'b001) ? BNE  :
							(Func3 == 3'b100) ? BLT  :
							(Func3 == 3'b101) ? BGE  :
							(Func3 == 3'b110) ? BLTU :
							(Func3 == 3'b111) ? BGEU ;
	
always@(*) 
begin 
	if (opcode == 7'b0110011)
		alu_out = Alu_result;
	else if (opcode == 7'b1100011)
		alu_out = branch_execution;
end
//ALu
module ALU
#(
	parameter WIDTH   =32
)
(
	input   [2:0]		  Func3,
	input   [7:0]		  Func7,
	input   [WIDTH-1:0]   oprend_1,
	input   [WIDTH-1:0]   oprend_2,
	output  [WIDTH-1:0]	  ALU_result,
	output  [WIDTH-1:0]	  branch_execution
); 

wire  [WIDTH-1:0]    	ADD;
wire  [WIDTH-1:0]    	SUB;
wire  [WIDTH-1:0]    	SLL;
wire  [WIDTH-1:0]    	SLT;
wire  [WIDTH-1:0]       SLTU;
wire  [WIDTH-1:0]    	XOR;
wire  [WIDTH-1:0]    	SRL;
wire  [WIDTH-1:0]    	SRA;
wire  [WIDTH-1:0]    	OR;
wire  [WIDTH-1:0]    	AND;
wire  [WIDTH-1:0]    	BEQ; 
wire  [WIDTH-1:0]    	BNE; 
wire  [WIDTH-1:0]    	BLT;	
wire  [WIDTH-1:0]    	BGE; 
wire  [WIDTH-1:0]    	BLTU; 
wire  [WIDTH-1:0]    	BGEU;	

assign 	ADD    = oprend_1 +  oprend_2;
assign 	SUB    = oprend_1 -  oprend_2;
assign 	SLL	   = oprend_1 << oprend_2;
assign 	SLT	   = $signed (oprend_1) <  $signed (oprend_2);
assign 	SLTU   = oprend_1 <  oprend_2; 
assign 	XOR    = oprend_1 ^  oprend_2; 
assign 	SRL    = oprend_1 >> oprend_2;
assign 	SRA    = oprend_1 >>> oprend_2;
assign 	OR     = oprend_1 |  oprend_2;
assign 	AND    = oprend_1 &  oprend_2;

always @*
begin 
	BEQ    = (oprend_1 ==  oprend_2) ? 32'h0000_0001 : 32'h0000_0000;
	BNE    = (oprend_1 != oprend_2) ? 32'h0000_0001 : 32'h0000_0000;
	BLT    = ($signed (oprend_1) < $signed (oprend_2)) ? 32'h0000_0001 : 32'h0000_0000;
	BGE    = ($signed (oprend_1) >= $signed (oprend_2)) ? 32'h0000_0001 : 32'h0000_0000;
    BLTU   = (oprend_1 < oprend_2) ? 32'h0000_0001 : 32'h0000_0000;
    BGEU   = (oprend_1 >= oprend_2) ? 32'h0000_0001 : 32'h0000_0000;
end 

assign ALU_result = (Func3 == 3'b000) ? (Func7 == 7'b0000000) ? ADD :
										(Func7 == 7'b0100000) ? SUB : 
					(Func3 == 3'b001) ? SLL :
					(Func3 == 3'b010) ? SLT :
					(Func3 == 3'b011) ? SLTU:
					(Func3 == 3'b100) ? XOR :
					(Func3 == 3'b101) ? (Func7 == 7'b0000000) ? SRL :
										(Func7 == 7'b0100000) ? SRA :
					(Func3 == 3'b110) ? OR  :
					(Func3 == 3'b111) ? AND ; 
					
					
assign branch_execution =   (Func3 == 3'b000) ? BEQ  :
							(Func3 == 3'b001) ? BNE  :
							(Func3 == 3'b100) ? BLT  :
							(Func3 == 3'b101) ? BGE  :
							(Func3 == 3'b110) ? BLTU :
							(Func3 == 3'b111) ? BGEU ;
	
endmodule
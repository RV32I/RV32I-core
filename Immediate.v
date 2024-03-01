module Immediate
#(
	parameter width = 32;
)
(
	input 	[width-1:0]	current_insrt,
	output 	[width-1:0] immediate
);

wire [width-1:0]   I_imm;
wire [width-1:0]   S_imm;
wire [width-1:0]   B_imm;
wire [width-1:0]   J_imm;
wire [width-1:0]   U_imm;

assign  U_imm   = $signed ({current_insrt[31:12], 12'b0})>>>11;
assign 	I_imm	= $signed ({current_insrt[31:20], 20'b0}) >>> 20; 
assign 	S_imm	= $signed ({current_insrt[31:25], current_insrt[11:7], 20'b0}) >>> 20;
assign 	B_imm	= $signed ({current_insrt[31], current_insrt[7], current_insrt[30:25], current_insrt[11:8],20'b0})>>> 20;  
assign 	J_imm	= $signed ({current_insrt[31], current_insrt[19:12], current_insrt[20], current_insrt[30:21], 12'b0})>>>11; 

assign immediate = (current_insrt[6:0] == 7'b0110111 || current_insrt[6:0]) ? U_imm:
				   (current_insrt[6:0] == 7'b1101111) ? J_imm:
				   (current_insrt[6:0] == 7'b1100111) ? I_imm:
				   (current_insrt[6:0] == 7'b1100011) ? B_imm:
				   (current_insrt[6:0] == 7'b0000011) ? I_imm:
				   (current_insrt[6:0] == 7'b0100011) ? S_imm:
				   (current_insrt[6:0] == 7'b0010011) ? I_imm;
				   
				
endmodule
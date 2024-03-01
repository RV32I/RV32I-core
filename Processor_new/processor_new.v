module processor
#(
	parameter  RAM_WIDTH 		= 32,
	parameter  RAM_DEPTH 		= 9,
	parameter  PROG_FILE		="",
	parameter  PROG_START_ADDR  =10,
	parameter  PROG_END_ADDR    =10,
	parameter  DATA_FILE        ="",
	parameter  DATA_START_ADDR  =10,
	parameter  DATA_END_ADDR    =10
)
(
	input clk,
	input reset
);

wire 		[RAM_WIDTH-1:0]		currInsrt;
wire		[RAM_WIDTH-1:0]		immediate;


reg  		[RAM_WIDTH-1:0]     INSRT;
reg  		[RAM_WIDTH-1:0]		PROG_ADDR_OUT;
reg  		[RAM_WIDTH-1:0]		DM_OUT;
reg  		[RAM_WIDTH-1:0]		REG_DATA_IN;
reg  		[RAM_WIDTH-1:0]		ALU_OUT;
reg			[RAM_WIDTH-1:0]		opr1;
reg			[RAM_WIDTH-1:0]		opr2;
reg			[RAM_WIDTH-1:0]		Reg_data1;
reg			[RAM_WIDTH-1:0]		Reg_data2;
reg			[RAM_WIDTH-1:0] 	prog_cnt;
reg			[RAM_WIDTH-1:0] 	branch;
reg			[RAM_WIDTH-1:0] 	j;
reg			[RAM_WIDTH-1:0] 	pc4;
reg			[RAM_WIDTH-1:0]		op1_sel;
reg			[RAM_WIDTH-1:0]		op2_sel;
wire 		[1:0] 				selpc;
wire 		[1:0]			    WBSEL;
wire        [1:0]				imm_sel;
wire 		INSRT[31:12]		LUI;
output reg  [PC_WIDTH-1:0] 		mux4t01;	

//program counter 	

always@(posedge clk)
begin 
	if (reset)
		prog_cnt <= 0;
	else
		prog_cnt <= mux4t01;
end

always@(*)
begin 
	case(selpc)
		2'b00   : mux4t01 = 
		2'b01   : mux4t01 = j;
		2'b10   : mux4t01 = branch;
		default : mux4t01 = pc4;
    endcase
end

always@* pc4 = prog_cnt + 4;


//instruction_memory
progam_memory
#(
	.RAM_WIDTH 			(RAM_WIDTH), 		
    .RAM_ADDR_BITS 	    (RAM_DEPTH),
    .PROG_FILE 		    (PROG_FILE), 	 		
    .INIT_START_ADDR 	(PROG_START_ADDR), 	
	.INIT_END_ADDR	    (PROG_END_ADDR)	
)	
inst_p_memory
(
	.clock			(clk),
    .ram_enable		(1'b1),	
	.write_enable	(1'b0),
    .address		(prog_cnt),
    .input_data		(0),	
    .output_data	(INSRT)
);

//reg addr select mux
always@* PROG_ADDR_OUT = WASEL ? 1 : INSRT;


//register file 
reg_file reg_file_inst
(
	.clk			(clk),
    .add_1			(INSRT[19:15]),
    .add_2			(INSRT[24:20]),
    .write_en		(),
    .write_addr		(PROG_ADDR_OUT),
    .wr_data		(REG_DATA_IN),
    .rd_data_1		(Reg_data1),
    .rd_data_2		(Reg_data2)
);	


//data memory
data_memory
#(
	.RAM_WIDTH 			(RAM_WIDTH), 		
    .RAM_ADDR_BITS 	    (RAM_DEPTH),		
	.DATA_FILE 		    (DATA_FILE),
    .INIT_START_ADDR 	(DATA_START_ADDR), 	
	.INIT_END_ADDR	    (DATA_END_ADDR)	
)	
inst_d_memory 
(
	.clock			(clk),
    .ram_enable		(1'b1),	
	.write_enable	(),
    .address		(ALU_OUT),
    .input_data		(Reg_data2),	
    .output_data	(DM_OUT)
);

//register write back select mux
always@(*)
begin 
	case(WBSEL)
		2'b00 : REG_DATA_IN = pc4;
		2'b01 : REG_DATA_IN = DM_OUT;
		2'b10 : REG_DATA_IN = ALU_OUT;
		2'b11 : REG_DATA_IN = LUI;
		endcase
end

//Oprend1 select mux

always@(*)
begin 
	case(op1_sel)
		2'b00 : opr1 = pc4;
		2'b01 : opr1 = INSRT[30:21];
		2'b10 : opr1 = Reg_data1;
end

//oprend2 select mux

always@(*)
begin 
	case(op2_sel
		2'b00 : opr2 = Reg_data2;
		2'b01 : opr2 = INSRT[31:12];
		2'b10 : opr2 = Imm_out;
end

//Imm select mux

always@(*)
begin 
	case(imm_sel)
		2'b00 : Imm_out = INSRT[31:20];
		2'b01 : Imm_out = INSRT[24:20];
		2'b10 : Imm_out = INSRT[31:25][11:7];
end

// branch adder

//always@* branch = pc4 + INSRT[31:25][11:7]; 
always@* branch = pc4 + INSRT[31:25][11:7];

//ALU

ALU 
#(
	.WIDTH          (RAM_WIDTH)
)
isnt_ALU
(
	.branch_execution	(clk),
    .ALU_result 		(reset),
    .oprend_2			(),
    .oprend_1			(opr1),
    .Func7				(),
    .Func3				(),
)

//Immediate generation
Immediate ImmGen
#(
	.width		(RAM_WIDTH)
)	
(
	.current_insrt		(currInsrt),
    .immediate			(immediate)
);
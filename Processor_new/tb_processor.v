module tb_processor;
reg clk;
reg reset;

processor	
#(
	.RAM_WIDTH 		(32             ),
    .RAM_DEPTH		(9              ),
    .DATA_FILE 		("data_file.txt"),
	.D_START_ADDR 	(0              ),
    .D_END_ADDR		(4              ),
    .PROG_FILE 		("prog_file.hex"),
    .START_ADDR 	(0              ),
    .END_ADDR	    (5              )
)
inst_processor
(
	.clk   	 (clk),
    .reset   (reset)
	
);	

initial 
begin 
	clk = 0;
	forever #1 clk = ~clk;
end 

initial
begin
	$dumpfile("waveform.vcd");
	$dumpvars(0,tb_processor);
	
	reset = 0;
	@(posedge clk);
	reset = 1;
	
	@(posedge clk);
	reset = 0;
	
	repeat(30) @(posedge clk);
	$finish;
end
endmodule
`include "register_file.v"
module register_tb();
	reg elk;
	reg nrst;
	reg[4:0] rd_addrA;
	reg[4:0] rd_addrB;
	reg[4:0] wr_addr; 
	reg wr_en;
	reg[31:0] wr_data;


	reg[31:0] R[31:0];
	integer ctr;
	reg tempA, tempB;
	output wire [31:0] rd_dataA;
	output wire [31:0] rd_dataB;
	
	integer counter;
	
	
initial begin
	$dumpfile("register_file.vcd");
	$dumpvars(0, elk, nrst, rd_addrA, rd_addrB, wr_addr, wr_en, wr_data, rd_dataA, rd_dataB);
	elk =1;
	
	#20
	wr_en = 1;
	wr_addr = 32'd8;
	wr_data = 32'h11111111;
	#6
	rd_addrA = wr_addr;	
	
	#25
	wr_en = 1;
	wr_addr = 32'd9;
	wr_data = 32'h22222222;
	#6
	rd_addrB = wr_addr;
	
	#10
	nrst = 0;
	#5
	nrst = 0;
	rd_addrA = wr_addr;	
	rd_addrB = wr_addr;
	
	#30
	
	$finish;
end


always begin
	
	#5 elk = ~elk; //toggle clock every 5 ticks

end

register_file U_register(elk, nrst, rd_addrA, rd_addrB, wr_addr, wr_en, wr_data, rd_dataA, rd_dataB);

endmodule
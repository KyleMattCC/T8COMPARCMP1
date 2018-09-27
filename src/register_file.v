//BUSTY BITS
//Calalan, Sherwin
//Chua, Kyle
//Cruz, Miguel
//Tirona, Paul
module register_file(
elk, nrst,
rd_addrA, rd_addrB,
wr_addr, wr_en, wr_data,
rd_dataA, rd_dataB
);

input wire elk, nrst;
input wire [4:0] rd_addrA, rd_addrB;
input wire [4:0] wr_addr;
input wire wr_en;
input wire [31:0] wr_data;
output reg [31:0] rd_dataA, rd_dataB;
reg [31:0] registers [31:0];
integer ctr;

initial begin //Reset at the beginning
	for(ctr=1; ctr<32; ctr++) begin
		registers[ctr] <= 32'd0;
	end

	rd_dataA <= 32'd0;
	rd_dataB <= 32'd0;
end

always @ (rd_addrA) begin //Execute when rd_addrA is changed
	rd_dataA = #1 registers[rd_addrA];
end

always @ (rd_addrB) begin //Execute when rd_addrB is changed
	rd_dataB = #1 registers[rd_addrB];
end

always @ (posedge elk) begin //Execute when clock is postive edge
	if(wr_en == 1'b1) begin //Check if write is enabled
		registers[wr_addr] = #1 wr_data;
	end
end

always @ (posedge nrst) begin //Execute when reset is asserted
	for(ctr=1; ctr<32; ctr++) begin
		registers[ctr] <= 32'd0;
	end

	rd_dataA <= 32'd0;
	rd_dataB <= 32'd0;
end

endmodule

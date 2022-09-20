module design_fifo # 
(
	parameter WIDTH =128,
	parameter DEPTH =4096
)
(
//global signals
input clk,
input rst,

//write fifo signals
//input from CPU
input wr_en,
input [WIDTH-1:0]wr_data,
//input from decoder 
input READ_ENABLE,
//outputs to decoder
output [WIDTH-1:0]READ_DATA,
output FIFO_EMPTY,
//output to CPU
output full,

// read fifo signals
// input from CPU
input rd_en,
//inputs from decoder
input [WIDTH-1:0]WRITE_DATA,
input WRITE_ENABLE,
//output to decoder
output FIFO_FULL,
//output to CPU
output [WIDTH-1:0]rd_data,
output empty

);
// Module Instantiations
// sync fifo

sync_fifo  write_fifo (
	.clk(clk),
	.rst(rst),
	.wr_en(wr_en),
	.wr_data(wr_data),
	.rd_en(READ_ENABLE),
	.rd_data(READ_DATA),
	.empty(FIFO_EMPTY),
	.full(full)

);

sync_fifo  read_fifo (
	.clk(clk),
	.rst(rst),
	.rd_en(rd_en),
	.rd_data(rd_data),
	.wr_en(WRITE_ENABLE),
	.wr_data(WRITE_DATA),
	.empty(empty),
	.full(FIFO_FULL)
);

endmodule

	








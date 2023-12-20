
interface fifo_if(input logic clk,rstn);
  logic wr_en;
  logic rd_en;
  logic full;
  logic empty;
  logic [127:0]wr_data;
  logic [127:0]rd_data;

  modport DRIVER(output wr_en,
                 output rd_en,
  	             input full,
                 input empty,
                 output wr_data,
                 input  rd_data,
                 input clk,
                 input rstn);

  /*modport DUT(input wr_en,
              input rd_en,
  	          output full,
              output empty,
              input wr_data,
              output  rd_data,
              input clk,
              input rst);   */

endinterface

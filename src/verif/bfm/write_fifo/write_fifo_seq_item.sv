`ifndef WRITE_FIFO_SEQ_ITEM_INCLUDED_
`define WRITE_FIFO_SEQ_ITEM_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: write_fifo_seq_item
// <Description_here>
//--------------------------------------------------------------------------------------------
class write_fifo_seq_item #(int ADDRESS_WIDTH=32,DATA_WIDTH=32,SIZE=3) extends uvm_sequence_item;
  //packet declaration
  const logic [7:0] sop=8'b01010101;
  const logic [7:0] eop=8'b10101011;
  packet = [];
  enum [2:0] type_of_axi ={axi_fifo_write_address_enable=0,
                           axi_fifo_write_data_enable1=1,
                           axi_fifo_read_address_enable=2,
                           axi_fifo_read_data_enable=3,
                           axi_fifo_response_enable=4};
  
  //write Address Channel
  rand bit [3:0] awid;
  rand bit [ADDRESS_WIDTH-1:0] awaddr;
  rand bit [3:0] awlen;
  rand bit [2:0] awsize;
  rand bit [1:0] awburst;
  //rand bit [1:0] awlock;
  //rand bit [3:0] awcache;
  //rand bit [2:0] awprot;
  //rand bit [3:0] awqos;
  //rand bit [3:0] awregion;
  //logic awuser;
  //logic awvalid;
  //logic awready;

  //Write data channel
  rand bit [DATA_WIDTH-1:0] wdata;
  rand bit [(DATA_WIDTH/8)-1:0] wstrb;
  rand bit wlast;
  logic [3:0] wuser;
  logic wvalid;
  logic wready;

  //Write response channel
  rand bit [3:0] bid;
  rand bit [1:0] bresp;
  rand bit [3:0] buser;
  rand  bit bvalid ;
  rand bit bready;

  //Read Address channel
  rand bit [3:0] arid;
  rand bit [ADDRESS_WIDTH-1:0] araddr;
  rand bit [7:0] arlen;
  rand bit [2:0] arsize;
  rand bit [1:0] arburst;
  rand bit [1:0] arlock;
  rand bit [3:0] arcache;
  rand bit [2:0] arprot;
  rand bit [3:0] arqos;
  rand bit [3:0] arregion;
  rand bit [3:0] aruser;
  logic arvalid;
  logic arready;

  //Read data channel
  rand bit [3:0] rid;
  rand bit [DATA_WIDTH-1:0 rdata;
  rand bit [1:0] rresp;
  logic [3:0] ruser;
  logic rvalid;
  logic rready;

  `uvm_object_param_utils_begin(write_fifo_seq_item#(ADDRESS_WIDTH,DATA_WIDTH,SIZE))
  
  `uvm_field_int(awid,UVM_ALL_ON)
  `uvm_field_int(awaddr,UVM_ALL_ON)
  `uvm_field_int(awlen,UVM_ALL_ON)
  `uvm_field_int(awsize,UVM_ALL_ON)
  `uvm_field_int(awburst.UVM_ALL_ON)
  `uvm_field_int(awlock,UVM_ALL_ON )
  `uvm_field_int(awcache,UVM_ALL_ON)
  `uvm_field_int(awprot,UVM_ALL_ON)
  `uvm_field_int(awqos,UVM_ALL_ON)
  `uvm_field_int(awregion,UVM_ALL_ON)
  
  `uvm_field_array_int(wdata,UVM_ALL_ON)
  `uvm_field_array_int(wstrb,UVM_ALL_ON)
  `uvm_field_array_int(wlast,UVM_ALL_ON)
  `uvm_field_array_int(wuser,UVM_ALL_ON)
  `uvm_field_array_int(wvalid,UVM_ALL_ON)
  `uvm_field_array_int(wready,UVM_ALL_ON)

  `uvm_field_int(bid,UVM_ALL_ON)
  `uvm_field_int(bresp,UVM_ALL_ON)
  `uvm_field_int(buser,UVM_ALL_ON)
  `uvm_field_int(bvalid,UVM_ALL_ON)
  `uvm_field_int(bready,UVM_ALL_ON)

  `uvm_field_int(arid,UVM_ALL_ON)
  `uvm_field_int(araddr,UVM_ALL_ON)
  `uvm_field_int(alen,UVM_ALL_ON)
  `uvm_field_int(arsize,UVM_ALL_ON)
  `uvm_field_int(arburst,UVM_ALL_ON)
  `uvm_field_int(arlock,UVM_ALL_ON)
  `uvm_field_int(arcache,UVM_ALL_ON)
  `uvm_field_int(arprot,UVM_ALL_ON)
  `uvm_field_int(arqos,UVM_ALL_ON)
  `uvm_field_int(arrigion,UVM_ALL_ON)
  `uvm_field_int(aruser,UVM_ALL_ON)
  `uvm_field_int(arvalid,UVM_ALL_ON)
  `uvm_field_int(arready,UVM_ALL_ON)

  `uvm_field_int(rid,UVM_ALL_ON)
  `uvm_field_array_int(rdata,UVM_ALL_ON)
  `uvm_field_int(rresp,UVM_ALL_ON)
  `uvm_field_int(rlast,UVM_ALL_ON)
  `uvm_field_int(rvalid,UVM_ALL_ON)
  `uvm_field_int(rready,UVM_ALL_ON)

function new(string name = "write_fifo_seq_item");
  super.new(name);
endfunction

`endif





















  






  `uvm_object_param_utils_begin(write_fifo_seq_item#(ADDRESS_WIDTH,DATA_WIDTH,IZE)



  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "write_fifo_seq_item");
endclass : write_fifo_seq_item

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - write_fifo_seq_item
//--------------------------------------------------------------------------------------------
function write_fifo_seq_item::new(string name = "write_fifo_seq_item");
  super.new(name);
endfunction : new

`endif



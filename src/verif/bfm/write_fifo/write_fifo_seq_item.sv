`ifndef WRITE_FIFO_SEQ_ITEM_INCLUDED_
`define WRITE_FIFO_SEQ_ITEM_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: write_fifo_seq_item
// <Description_here>
//--------------------------------------------------------------------------------------------
class fifo_sequence_item #(int ADDRESS_WIDTH=32,DATA_WIDTH=32) extends uvm_sequence_item;
  //packet declaration
  const logic [7:0] sop=8'b01010101;
  const logic [7:0] eop=8'b10101011;
  // int packet [];
  enum bit [2:0] {axi_fifo_write_address_enable=0,
                           axi_fifo_write_data_enable1=1,
                           axi_fifo_read_address_enable=2,
                           axi_fifo_read_data_enable=3,
                           axi_fifo_response_enable=4} type_of_axi;
  
  //write Address Channel
  rand bit [3:0] awid;
  rand bit [ADDRESS_WIDTH-1:0] awaddr;
  rand bit [3:0] awlen;
  rand bit [2:0] awsize;
  rand bit [1:0] awburst;
  rand bit [1:0] awlock;
  rand bit [3:0] awcache;
  rand bit [2:0] awprot;
  rand bit [3:0] awqos;
  rand bit [3:0] awregion;
 // logic awuser;
 // logic awvalid;
 // logic awready;

  //Write data channel
  rand bit [DATA_WIDTH-1:0] wdata;
  rand bit [(DATA_WIDTH/8)-1:0] wstrb;
  rand bit wlast;
  rand bit [3:0] wid;
 // logic [3:0] wuser;
 // logic wvalid;
 // logic wready;

  //Write response channel
  rand bit [3:0] bid;
  rand bit [1:0] bresp;
 // rand bit [3:0] buser;
 // rand  bit bvalid ;
 // rand bit bready;

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
 // rand bit [3:0] aruser;
 // logic arvalid;
 // logic arready;

  //Read data channel
  rand bit [3:0] rid;
  rand bit [DATA_WIDTH-1:0] rdata;
  rand bit [1:0] rresp;
 // logic [3:0] ruser;
 // logic rvalid;
 // logic rready;
  bit rlast;

  `uvm_object_param_utils_begin(fifo_sequence_item#(ADDRESS_WIDTH,DATA_WIDTH))
  
  `uvm_field_int(awid,UVM_ALL_ON)
  `uvm_field_int(awaddr,UVM_ALL_ON)
  `uvm_field_int(awlen,UVM_ALL_ON)
  `uvm_field_int(awsize,UVM_ALL_ON)
  `uvm_field_int(awburst,UVM_ALL_ON)
  `uvm_field_int(awlock,UVM_ALL_ON )
  `uvm_field_int(awcache,UVM_ALL_ON)
  `uvm_field_int(awprot,UVM_ALL_ON)
  `uvm_field_int(awqos,UVM_ALL_ON)
  `uvm_field_int(awregion,UVM_ALL_ON)
  
  `uvm_field_int(wdata,UVM_ALL_ON)
  `uvm_field_int(wstrb,UVM_ALL_ON)
  `uvm_field_int(wlast,UVM_ALL_ON)
 // `uvm_field_int(wuser,UVM_ALL_ON)
 // `uvm_field_int(wvalid,UVM_ALL_ON)
 // `uvm_field_int(wready,UVM_ALL_ON)
  `uvm_field_int(wid,UVM_ALL_ON)

  `uvm_field_int(bid,UVM_ALL_ON)
  `uvm_field_int(bresp,UVM_ALL_ON)
 // `uvm_field_int(buser,UVM_ALL_ON)
 // `uvm_field_int(bvalid,UVM_ALL_ON)
 // `uvm_field_int(bready,UVM_ALL_ON)

  `uvm_field_int(arid,UVM_ALL_ON)
  `uvm_field_int(araddr,UVM_ALL_ON)
  `uvm_field_int(arlen,UVM_ALL_ON)
  `uvm_field_int(arsize,UVM_ALL_ON)
  `uvm_field_int(arburst,UVM_ALL_ON)
  `uvm_field_int(arlock,UVM_ALL_ON)
  `uvm_field_int(arcache,UVM_ALL_ON)
  `uvm_field_int(arprot,UVM_ALL_ON)
  `uvm_field_int(arqos,UVM_ALL_ON)
  `uvm_field_int(arregion,UVM_ALL_ON)
 // `uvm_field_int(aruser,UVM_ALL_ON)
 // `uvm_field_int(arvalid,UVM_ALL_ON)
 // `uvm_field_int(arready,UVM_ALL_ON)

  `uvm_field_int(rid,UVM_ALL_ON)
  `uvm_field_int(rdata,UVM_ALL_ON)
  `uvm_field_int(rresp,UVM_ALL_ON)
  `uvm_field_int(rlast,UVM_ALL_ON)
 // `uvm_field_int(rvalid,UVM_ALL_ON)
 // `uvm_field_int(rready,UVM_ALL_ON)

  `uvm_object_utils_end
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "fifo_sequence_item");
endclass : fifo_sequence_item

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - write_fifo_seq_item
//--------------------------------------------------------------------------------------------
function fifo_sequence_item::new(string name = "fifo_sequence_item");
  super.new(name);
endfunction : new

`endif

`ifndef FIFO_BFM_RD_SEQ_INCLUDED_
`define FIFO_BFM_RD_SEQ_INCLUDED_


class fifo_bfm_rd_seq extends fifo_bfm_base_seq;

`uvm_object_utils(fifo_bfm_rd_seq)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "fifo_bfm_rd_seq", uvm_component parent = null);
  extern virtual task body();

endclass:fifo_bfm_rd_seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes fifo_bfm_rd_seq class object
//
// Parameters:
//  name - fifo_bfm_rd_seq
//-----------------------------------------------------------------------------

function fifo_bfm_rd_seq::new(string name="fifo_bfm_rd_seq");
super.new(name);
endfunction:new

//--------------------------------------------------------------------------------------------
// Task: body
// task for fifo rd type sequence
//--------------------------------------------------------------------------------------------

task fifo_bfm_rd_seq::body(); 
begin
  fifo_sequence_item req;
  req=fifo_sequence_item::type_id::create("req");
  start_item(req);
  assert(req.randomize()with{req.we==0 && req.re==1;})
  finish_item(req);
end
endtask:body

`endif

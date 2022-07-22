`ifndef FIFO_BFM_RESET_SEQ_INCLUDED_
`define FIFO_BFM_RESET_SEQ_INCLUDED_

class fifo_bfm_reset_seq extends fifo_bfm_base_seq;

`uvm_object_utils(fifo_bfm_reset_seq)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "fifo_bfm_reset_seq", uvm_component parent = null);
  extern virtual task body();

endclass:fifo_bfm_reset_seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes fifo_bfm_reset_seq class object
//
// Parameters:
//  name - fifo_bfm_reset_seq
//-----------------------------------------------------------------------------

function fifo_bfm_reset_seq::new(string name="fifo_bfm_reset_seq");
super.new(name);
endfunction:new

//--------------------------------------------------------------------------------------------
// Task: body
// task for fifo reset type sequence
//--------------------------------------------------------------------------------------------

task fifo_bfm_reset_seq::body(); 
begin
  fifo_sequence_item req;
  req=fifo_sequence_item::type_id::create("req");
  start_item(req);
  assert(req.randomize()with{req.reset==0;})
  finish_item(req);
end
endtask:body

`endif

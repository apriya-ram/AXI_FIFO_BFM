`ifndef FIFO_BFM_WRITE_FULL_SEQ_INCLUDED_
`define FIFO_BFM_WRITE_FULL_SEQ_INCLUDED_


class fifo_bfm_write_full_seq extends fifo_bfm_base_seq;

`uvm_object_utils(fifo_bfm_write_full_seq)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "fifo_bfm_write_full_seq", uvm_component parent = null);
  extern virtual task body();

endclass:fifo_bfm_write_full_seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes fifo_bfm_write_full_seq class object
//
// Parameters:
//  name - fifo_bfm_write_full_seq
//-----------------------------------------------------------------------------

function fifo_bfm_write_full_seq::new(string name="fifo_bfm_write_full_seq");
super.new(name);
endfunction:new

//--------------------------------------------------------------------------------------------
// Task: body
// task for fifo write full type sequence
//--------------------------------------------------------------------------------------------

task fifo_bfm_write_full_seq::body(); 
begin
  fifo_sequence_item req;
  req=fifo_sequence_item::type_id::create("req");
  start_item(req);
  assert(req.randomize()with{req.full==1 && req.we==1;})
  finish_item(req);
end
endtask:body

`endif

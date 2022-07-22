`ifndef FIFO_BFM_RESET_SEQ_INCLUDED_
`define FIFO_BFM_RESET_SEQ_INCLUDED_

class fifo_bfm_reset_seq extends fifo_bfm_base_seq;

//factory registeration
`uvm_object_utils(fifo_bfm_reset_seq)

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes fifo_bfm_reset_seq class object
//
// Parameters:
//  name - fifo_bfm_reset_seq
//-----------------------------------------------------------------------------

function new(string name="fifo_bfm_reset_seq");
super.new(name);
endfunction

//--------------------------------------------------------------------------------------------
// Task: body
// task for fifo reset type sequence
//--------------------------------------------------------------------------------------------

task body(); 
begin
  fifo_sequence_item req;
  req=fifo_sequence_item::type_id::create("req");
  start_item(req);
  assert(req.randomize()with{req.reset==0;})
  finish_item(req);
end
endtask

endclass

`endif

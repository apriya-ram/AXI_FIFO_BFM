`ifndef FIFO_BFM_BASE_SEQ_INCLUDED_
`define FIFO_BFM_BASE_SEQ_INCLUDED_

class fifo_bfm_base_seq extends uvm_sequence#(fifo_sequence_item);

`uvm_object_utils(fifo_bfm_base_seq )

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "fifo_bfm_base_seq");
  extern virtual task body();

endclass:fifo_bfm_base_seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes fifo_bfm_base_sequence class object
//
// Parameters:
//  name - fifo_bfm_base_seq
//-----------------------------------------------------------------------------
function fifo_bfm_base_seq::new(string name="fifo_bfm_base_seq");
super.new(name);
endfunction:new

task fifo_bfm_base_seq::body();
  $display("body");
endtask : body

`endif

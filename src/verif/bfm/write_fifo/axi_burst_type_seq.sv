`ifndef AXI_BURST_TYPE_SEQ_INCLUDED_
`define AXI_BURST_TYPE_SEQ_INCLUDED_

typedef enum bit[1:0] { FIXED, INCR, WRAP } B_TYPE;
//--------------------------------------------------------------------------------------------
// Class: axi_burst_type_seq 
// creating axi_burst__type_seq class extends from fifo_bfm_base_seq
// This class provides the Burst type write_read sequence
//--------------------------------------------------------------------------------------------

class axi_burst_type_seq extends fifo_bfm_base_seq;

  //factory registration
  `uvm_object_utils(axi_burst_type_seq)
  
  //Declare the B_TYPE 
  B_TYPE b_type;
  
  //-------------------------------------------------------
  // Externally defined Function
  //-------------------------------------------------------
  extern function new(string name = "axi_burst_type_seq");
  extern task body();

endclass : axi_burst_type_seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes axi_burst_type_sequence class object
//
// Parameters:
//  name - axi_burst_type_seq
//-----------------------------------------------------------------------------
function axi_burst_type_seq::new(string name = "axi_burst_type_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: body
// task for AXI burst type sequence
//--------------------------------------------------------------------------------------------
task axi_burst_type_seq::body();
  super.body();
  
  start_item(pkt);
    
  //if(cfg.burst_type == 0)
  //          assert(pkt.randomize() with { b_type == FIXED; });
  //else if(cfg.burst_type == 1)
  //          assert(pkt.randomize() with { b_type == INCR; });
  //else if(cfg.burst_type == 2)
  //          assert(pkt.randomize() with { b_type == WRAP; });
  //else
            assert(pkt.randomize());
  finish_item(pkt);
  //end

endtask : body

`endif




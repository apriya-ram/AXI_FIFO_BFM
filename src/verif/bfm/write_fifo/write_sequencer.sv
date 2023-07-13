`ifndef WRITE_FIFO_SEQUENCER_INCLUDED_
`define WRITE_FIFO_SEQUENCER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: write_fifo_sequencer
// <Description_here>
//--------------------------------------------------------------------------------------------
class write_fifo_sequencer extends uvm_sequencer#(fifo_sequence_item);
  `uvm_component_utils(write_fifo_sequencer)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "write_fifo_sequencer", uvm_component parent );
  extern virtual function void build_phase(uvm_phase phase);

endclass : write_fifo_sequencer

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - write_fifo_sequencer
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function write_fifo_sequencer::new(string name = "write_fifo_sequencer",
                                 uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void write_fifo_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

`endif
                     



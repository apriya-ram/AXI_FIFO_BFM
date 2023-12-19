`ifndef WRITE_FIFO_SEQUENCER_INCLUDED_
`define WRITE_FIFO_SEQUENCER_INCLUDED_
class write_fifo_sequencer extends uvm_sequencer#(write_fifo_seq_item);
  `uvm_component_utils(write_fifo_sequencer)

  function new(string name="write_fifo_sequencer",uvm_component parent =null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

endclass

`endif

  

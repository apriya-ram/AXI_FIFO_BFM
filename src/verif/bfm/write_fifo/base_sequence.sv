`ifndef BASE_SEQUENCE_INCLUDED_
`define BASE_SEQUENCE_INCLUDED_

class base_sequence extends uvm_sequence#(write_fifo_seq_item);

  `uvm_object_utils(base_sequence)

  function new(string name="base_sequence", uvm_component parent = null);
    super.new(name);
  endfunction

endclass
`endif

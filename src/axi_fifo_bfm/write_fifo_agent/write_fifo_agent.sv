`ifndef WRITE_FIFO_AGENT_INCLUDED_
`define WRITE_FIFO_AGENT_INCLUDED_

class write_fifo_agent extends uvm_agent;
  `uvm_component_utils(write_fifo_agent)
  
  write_fifo_driver write_fifo_driver_h;
  write_fifo_monitor write_fifo_monitor_h;
  write_fifo_sequencer write_fifo_sequencer_h;

  function new(string name = "write_fifo_agent", uvm_component parent = null);
    super.new(name,parent);
  endfunction
    
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    write_fifo_sequencer_h = write_fifo_sequencer::type_id::create("write_fifo_sequencer_h",this);
    write_fifo_driver_h = write_fifo_driver::type_id::create("write_fifo_driver_h",this);
    write_fifo_monitor_h = write_fifo_monitor::type_id::create("write_fifo_monitor_h",this);

  endfunction


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    write_fifo_driver_h.seq_item_port.connect(write_fifo_sequencer_h.seq_item_export);

  endfunction

endclass
`endif

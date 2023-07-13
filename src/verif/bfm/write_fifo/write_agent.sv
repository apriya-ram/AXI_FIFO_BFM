`ifndef WRITE_FIFO_AGENT_INCLUDED_
`define WRITE_FIFO_AGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: write_fifo_agent
// <Description_here>
//--------------------------------------------------------------------------------------------
class write_fifo_agent extends uvm_agent;
  `uvm_component_utils(write_fifo_agent)

  //variable sequencer
  //Declaring the sequencer handle
  write_fifo_sequencer sequencer;

  //variable driver
  //Declaring driver handle
  write_fifo_driver driver;

  //variable monitor
  //Declaring the monitor handle
  fifo_bfm_monitor monitor;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "write_fifo_agent", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : write_fifo_agent

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - write_fifo_agent
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function write_fifo_agent::new(string name = "write_fifo_agent",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void write_fifo_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  sequencer=write_fifo_sequencer::type_id::create("sequencer",this);
  driver=write_fifo_driver::type_id::create("driver",this);
  monitor=fifo_bfm_monitor::type_id::create("monitor",this);

endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void write_fifo_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  //Connecting the TLM port driver of the port to sequencer of the export
  driver.seq_item_port.connect(sequencer.seq_item_export);


endfunction : connect_phase


`endif


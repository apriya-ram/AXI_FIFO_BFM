`ifndef READ_FIFO_AGENT_INCLUDED_
`define READ_FIFO_AGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: read_fifo_agent
// <Description_here>
//--------------------------------------------------------------------------------------------

class read_fifo_agent extends uvm_component;
  `uvm_component_utils(read_fifo_agent)

  //variable mon_h
  //Declaring the monitor handle
  read_fifo_monitor read_monitor;
   
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "read_fifo_agent", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : read_fifo_agent

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - read_fifo_agent
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function read_fifo_agent::new(string name = "read_fifo_agent",
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
function void read_fifo_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  read_monitor=read_fifo_monitor::type_id::create("read_monitor",this);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void read_fifo_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase


`endif


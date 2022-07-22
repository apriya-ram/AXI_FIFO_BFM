`ifndef AXI_HANDSHAKING_TEST_INCLUDED_
`define AXI_HANDSHAKING_TEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi_handshaking_test
// Extends the axi handshaking test 
//--------------------------------------------------------------------------------------------
class axi_handshaking_test extends fifo_bfm_base_test;
  `uvm_component_utils(axi_handshaking_test)

  //Instantiation of axi_handshaking_seq
  axi_handshaking_seq handshaking_seq;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi_handshaking_test", uvm_component parent = null);
  extern virtual task run_phase(uvm_phase phase);

endclass : axi_handshaking_test

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi_handshaking_test
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function axi_handshaking_test::new(string name = "axi_handshaking_test", uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: run_phase
// Creates the axi_handshaking_seq sequence
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task axi_handashaking_test::run_phase(uvm_phase phase);

  handshaking_seq=axi_handshaking_seq::type_id::create("handshaking_seq");
  `uvm_info(get_type_name(),$sformatf("axi_handshaking_test"),UVM_LOW);
  phase.raise_objection(this);
  handshaking_seq.start(axi_env_h.wr_fifo_agent_h.wr_fifo_sqr);
  phase.drop_objection(this);

endtask : run_phase

`endif




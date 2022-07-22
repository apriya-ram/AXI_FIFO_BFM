`ifndef AXI_BURST_TYPE_TEST_INCLUDED_
`define AXI_BURST_TYPE_TEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi_burst_type_test
// Extends the fifo base test 
//--------------------------------------------------------------------------------------------
class axi_burst_type_test extends fifo_base_test;
  `uvm_component_utils(axi_burst_type_test)

  //Instatiation of axi_burst_type_seq
  axi_burst_type_seq burst_typ_seq;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi_burst_type_test", uvm_component parent = null);
  extern virtual task run_phase(uvm_phase phase);

endclass : axi_burst_type_test

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi_burst_type_test
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function axi_burst_type_test::new(string name = "axi_burst_type_test", uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: run_phase
// Creates the axi_burst_type_seq sequence
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task axi_burst_type_test::run_phase(uvm_phase phase);

  burst_typ_seq=axi_burst_type_seq::type_id::create("burst_typ_seq");
  `uvm_info(get_type_name(),$sformatf("axi_burst_type_test"),UVM_LOW);
  phase.raise_objection(this);
  burst_typ_seq.start(axi_env_h.wr_fifo_agent_h.wr_fifo_sqr);
  phase.drop_objection(this);

endtask : run_phase

`endif



`ifndef FIFO_BFM_READ_EMPTY_TEST_INCLUDED_
`define FIFO_BFM_READ_EMPTY_TEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: fifo_bfm_read_empty_test
// Extends the fifo base test 
//--------------------------------------------------------------------------------------------
class fifo_bfm_read_empty_test extends fifo_bfm_base_test;
  `uvm_component_utils(fifo_bfm_read_empty_test)

  //Instatiation of fifo_bfm_read_empty_seq
  fifo_bfm_read_empty_seq fifo_read_empty_seq;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "fifo_bfm_read_empty_test", uvm_component parent = null);
  extern virtual task run_phase(uvm_phase phase);

endclass : fifo_bfm_read_empty_test

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - fifo_bfm_read_empty_test
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function fifo_bfm_read_empty_test::new(string name = "fifo_bfm_read_empty_test",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: run_phase
// Creates the fifo_bfm_read_empty_seq sequence
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task fifo_bfm_read_empty_test::run_phase(uvm_phase phase);

  fifo_read_empty_seq=fifo_bfm_read_empty_seq::type_id::create("fifo_read_empty_seq");
  `uvm_info(get_type_name(),$sformatf("fifo_bfm_read_empty_test"),UVM_LOW);
  phase.raise_objection(this);
  fifo_read_empty_seq.start(axi_env_h.wr_fifo_agent_h.wr_fifo_sqr);
  phase.drop_objection(this);

endtask : run_phase

`endif








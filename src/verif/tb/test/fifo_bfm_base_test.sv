`ifndef FIFO_BFM_BASE_TEST_INCLUDED_
`define FIFO_BFM_BASE_TEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: fifo_bfm_base_test
// Extends the uvm test 
//--------------------------------------------------------------------------------------------
class fifo_bfm_base_test extends uvm_test;
  `uvm_component_utils(fifo_bfm_base_test)

  //Instatiation of fifo_bfm_base_seq
  fifo_bfm_base_seq fifo_base_seq;

  axi_env axi_env_h;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "fifo_bfm_base_test", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : fifo_bfm_base_test

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - fifo_bfm_base_test
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function fifo_bfm_base_test::new(string name = "fifo_bfm_base_test", uvm_component parent = null);
  super.new(name, parent);
endfunction : new


function void fifo_bfm_base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  axi_env_h = axi_env::type_id::create("axi_env_h",this);
endfunction : build_phase

function void fifo_bfm_base_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
  uvm_test_done.set_drain_time(this,3000ns);
endfunction : end_of_elaboration_phase


//--------------------------------------------------------------------------------------------
// Task: run_phase
// Creates the fifo_bfm_base_seq sequence
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------

task fifo_bfm_base_test::run_phase(uvm_phase phase);

  fifo_base_seq=fifo_bfm_base_seq::type_id::create("fifo_base_seq");
  `uvm_info(get_type_name(),$sformatf("fifo_bfm_base_test"),UVM_LOW);
  phase.raise_objection(this);
  fifo_base_seq.start(axi_env_h.write_fifo_agent_h.sequencer);
  //fifo_base_seq.start(null);
  phase.drop_objection(this);

endtask : run_phase

`endif






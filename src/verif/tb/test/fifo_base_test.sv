`ifndef FIFO_BASE_TEST_INCLUDED_
`define FIFO_BASE_TEST_INCLUDED_


class fifo_base_test extends uvm_test;
  `uvm_component_utils(fifo_base_test)

  base_sequence base_sequence_h;
  env env_h;

  function new(string name="fifo_base_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    base_sequence_h = base_sequence::type_id::create("base_sequence_h");
    env_h = env::type_id::create("env_h",this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
    uvm_test_done.set_drain_time(this,3000ns);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(),$sformatf("fifo_base_test"),UVM_LOW)
    phase.raise_objection(this);
    base_sequence_h.start(env_h.write_fifo_agent_h.write_fifo_sequencer_h);
    phase.drop_objection(this);

  endtask
endclass
`endif

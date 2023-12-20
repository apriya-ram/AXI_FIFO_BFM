`ifndef WRITE_TEST_INCLUDED_
`define WRITE_TEST_INCLUDED_

class write_test extends fifo_base_test;
  `uvm_component_utils(write_test)
  //axi4_slave_nbk_write_32b_transfer_seq axi4_slave_nbk_write_32b_transfer_seq_h;
  write_fifo_sequence write_fifo_sequence_h;
  
  function new(string name="write_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    write_fifo_sequence_h=write_fifo_sequence::type_id::create("write_fifo_sequence_h");
    //axi4_slave_nbk_write_32b_transfer_seq_h=axi4_slave_nbk_write_32b_transfer_seq::type_id::create("axi4_slave_nbk_write_32b_transfer_seq_h");
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(),$sformatf("write test"),UVM_LOW);
    phase.raise_objection(this);
   /* fork
      forever begin
      axi4_slave_nbk_write_32b_transfer_seq_h.start();
    end
    join_none*/
    write_fifo_sequence_h.start(env_h.write_fifo_agent_h.write_fifo_sequencer_h);
    #100000;
    phase.drop_objection(this);

  endtask
endclass
`endif

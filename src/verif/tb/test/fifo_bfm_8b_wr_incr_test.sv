`ifndef FIFO_BFM_8B_WR_INCR_TEST_INCLUDED_
`define FIFO_BFM_8B_WR_INCR_TEST_INCLUDED_

class fifo_bfm_8b_wr_incr_test extends fifo_base_test;
  `uvm_component_utils(fifo_bfm_8b_wr_incr_test)

  fifo_bfm_8b_wr_incr_sequence fifo_bfm_8b_wr_incr_sequence_h;
  axi4_slave_nbk_write_32b_transfer_seq axi4_slave_nbk_write_32b_transfer_seq_h;

  function new(string name="fifo_bfm_8b_wr_incr_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    axi4_slave_nbk_write_32b_transfer_seq_h = axi4_slave_nbk_write_32b_transfer_seq::type_id::create("axi4_slave_nbk_read_64b_transfer_seq_h");
    fifo_bfm_8b_wr_incr_sequence_h=fifo_bfm_8b_wr_incr_sequence::type_id::create("fifo_bfm_8b_wr_incr_sequence_h");
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(),$sformatf("fifo_bfm_8b_wr_incr_test"),UVM_LOW)

    phase.raise_objection(this);
      fork
        begin
          forever begin
            axi4_slave_nbk_write_32b_transfer_seq_h.start(env_h.axi_slave_agent_h.axi4_slave_write_seqr_h);
        end
      end
    join_none

    fifo_bfm_8b_wr_incr_sequence_h.start(env_h.write_fifo_agent_h.write_fifo_sequencer_h);
  phase.drop_objection(this);
  endtask
endclass
`endif
    


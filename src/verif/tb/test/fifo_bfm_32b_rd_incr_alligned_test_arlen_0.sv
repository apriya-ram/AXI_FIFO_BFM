`ifndef FIFO_BFM_32B_RD_INCR_ALLIGNED_TEST_ARLEN_0_INCLUDED_
`define FIFO_BFM_32B_RD_INCR_ALLIGNED_TEST_ARLEN_0_INCLUDED_

class fifo_bfm_32b_rd_incr_alligned_test_arlen_0 extends fifo_base_test;
  `uvm_component_utils(fifo_bfm_32b_rd_incr_alligned_test_arlen_0)
  //bit[31:0] wdata_seq[$];
  bit[3:0] arlenn = 8;
  bit [31:0] addr;//=$urandom;
  //bit[3:0] wstrbb=4'hf;
  bit[1:0] arburstt = 1;
  bit[2:0] arsizee = 2;

  fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0 fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0_h;
  //axi4_slave_nbk_write_32b_transfer_seq axi4_slave_nbk_write_32b_transfer_seq_h;
  axi4_slave_nbk_read_32b_transfer_seq axi4_slave_nbk_read_32b_transfer_seq_h;
 // axi4_slave_nbk_write_64b_transfer_seq axi4_slave_nbk_write_64b_transfer_seq_h;
 // axi4_slave_nbk_read_64b_transfer_seq axi4_slave_nbk_read_64b_transfer_seq_h;
  

  function new(string name = "fifo_bfm_32b_rd_incr_alligned_test_arlen_0",uvm_component parent = null);
    super.new(name, parent);
    void'(std::randomize(addr) with {addr%((2**arsizee)*8)==0;});
    $display("address in sequence=%h",addr);
   // void'(std::randomize(wdata_seq) with {wdata_seq.size()==arlenn+1;});
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   // axi4_slave_nbk_write_32b_transfer_seq_h = axi4_slave_nbk_write_32b_transfer_seq::type_id::create("axi4_slave_nbk_write_32b_transfer_seq_h");
    axi4_slave_nbk_read_32b_transfer_seq_h = axi4_slave_nbk_read_32b_transfer_seq::type_id::create("axi4_slave_nbk_read_32b_transfer_seq_h");
    //axi4_slave_nbk_read_64b_transfer_seq_h = axi4_slave_nbk_read_64b_transfer_seq::type_id::create("axi4_slave_nbk_read_64b_transfer_seq_h");
    fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0_h=fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0::type_id::create("fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0_h");
   // axi4_slave_nbk_write_64b_transfer_seq_h = axi4_slave_nbk_write_64b_transfer_seq::type_id::create("axi4_slave_nbk_write_64b_transfer_seq_h");
    
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(),$sformatf("fifo_bfm_32b_rd_incr_alligned_test_arlen_0"),UVM_LOW)

    phase.raise_objection(this);
     // fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0_h.arlen=1;
      fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0_h.arlenn=arlenn;
      fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0_h.addr=addr;
      //fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0_h.wstrbb=wstrbb;
      fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0_h.arburstt=arburstt;
      fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0_h.arsizee=arsizee;
     // fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0_h.wdata_seq=wdata_seq;

      fork
        begin
          forever begin
          //  axi4_slave_nbk_write_32b_transfer_seq_h.start(env_h.axi_slave_agent_h.axi4_slave_write_seqr_h);
           //axi4_slave_nbk_write_64b_transfer_seq_h.start(env_h.axi_slave_agent_h.axi4_slave_write_seqr_h);
            
           axi4_slave_nbk_read_32b_transfer_seq_h.start(env_h.axi_slave_agent_h.axi4_slave_read_seqr_h);
     //      axi4_slave_nbk_read_64b_transfer_seq_h.start(env_h.axi_slave_agent_h.axi4_slave_read_seqr_h);
        end
      end
    join_none

    fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0_h.start(env_h.write_fifo_agent_h.write_fifo_sequencer_h);
  phase.drop_objection(this);
  endtask
endclass
`endif

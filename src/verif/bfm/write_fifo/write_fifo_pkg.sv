`ifndef WRITE_FIFO_PKG_INCLUDED_
`define WRITE_FIFO_PKG_INCLUDED_

package write_fifo_pkg;
  
  //Import uvm package
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_globals_pkg::*;
  
  `include "write_fifo_seq_item.sv"
  `include "write_fifo_sequencer.sv"
  `include "write_fifo_driver.sv"
  `include "write_fifo_monitor.sv"
  `include "write_fifo_agent.sv"

  `include "base_sequence.sv"
  `include "write_fifo_sequence.sv"
  `include "fifo_bfm_8b_wr_incr_sequence.sv"
  `include "fifo_bfm_8b_wr_fixed_sequence.sv"
  `include "fifo_bfm_32b_wr_incr_alligned_sequence_awlen_0.sv"
  `include "fifo_bfm_64b_wr_incr_alligned_sequence_awlen_1.sv"
  `include "fifo_bfm_96b_wr_incr_alligned_sequence_awlen_2.sv"
  `include "fifo_bfm_128b_wr_incr_alligned_sequence_awlen_3.sv"
  `include "fifo_bfm_8b_wr_incr_unalligned_sequence_awlen_0.sv"
  `include "fifo_bfm_16b_wr_incr_unalligned_sequence_awlen_0.sv"
  `include "fifo_bfm_16b_wr_incr_unalligned_sequence_awlen_1.sv"
  `include "fifo_bfm_24b_wr_incr_unalligned_sequence_awlen_0.sv"
  `include "fifo_bfm_40b_wr_incr_unalligned_sequence_awlen_1.sv"
  `include "fifo_bfm_56b_wr_incr_unalligned_sequence_awlen_1.sv"
  `include "fifo_bfm_80b_wr_incr_unalligned_sequence_awlen_2.sv"
  `include "fifo_bfm_wr_incr_alligned_sequence.sv"
  `include "fifo_bfm_wr_incr_alligned_sequence.sv"


  `include "fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0.sv"


endpackage

`endif

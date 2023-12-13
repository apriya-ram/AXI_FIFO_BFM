
`ifndef SEQUENCE_PKG_INCLUDED_
`define SEQUENCE_PKG_INCLUDED_

package sequence_pkg;
  
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_globals_pkg::*;

  import write_fifo_pkg::*;
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


  `include "fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0.sv"

endpackage
`endif

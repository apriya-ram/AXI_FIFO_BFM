`ifndef TEST_PKG_INCLUDED_
`define TEST_PKG_INCLUDED_

package test_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_globals_pkg::*;
  import axi4_slave_seq_pkg::*;

  import write_fifo_pkg::*;
  import env_package::*;
 // import sequence_pkg::*; 

  `include "test.sv"
  `include "write_test.sv"
  `include "fifo_bfm_8b_wr_incr_test.sv"
  `include "fifo_bfm_8b_wr_fixed_test.sv"
  `include "fifo_bfm_32b_wr_incr_alligned_test_awlen_0.sv"
  `include "fifo_bfm_64b_wr_incr_alligned_test_awlen_1.sv"
  `include "fifo_bfm_96b_wr_incr_alligned_test_awlen_2.sv"
  `include "fifo_bfm_128b_wr_incr_alligned_test_awlen_3.sv"
  `include "fifo_bfm_8b_wr_incr_unalligned_test_awlen_0.sv"
  `include "fifo_bfm_16b_wr_incr_unalligned_test_awlen_0.sv"
  `include "fifo_bfm_16b_wr_incr_unalligned_test_awlen_1.sv"
  `include "fifo_bfm_24b_wr_incr_unalligned_test_awlen_0.sv"
  `include "fifo_bfm_40b_wr_incr_unalligned_test_awlen_1.sv"
  `include "fifo_bfm_56b_wr_incr_unalligned_test_awlen_1.sv"
  `include "fifo_bfm_80b_wr_incr_unalligned_test_awlen_2.sv"
  `include "fifo_bfm_32b_wr_incr_alligned_test_awlen_0_to_3.sv"
  `include "fifo_bfm_32b_wr_incr_alligned_test_awlen_4_to_7.sv"
  `include "fifo_bfm_32b_wr_incr_alligned_test_awlen_8_to_11.sv"
  `include "fifo_bfm_32b_wr_incr_alligned_test_awlen_12_to_15.sv"

  `include "fifo_bfm_32b_rd_incr_alligned_test_arlen_0.sv"
endpackage
`endif

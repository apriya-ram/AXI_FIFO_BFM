`ifndef TEST_PKG_INCLUDED_
`define TEST_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: axi4_env_pkg
// Includes all the files related to axi4 env
//--------------------------------------------------------------------------------------------
package test_pkg;
  
  //Import uvm package
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_globals_pkg::*;
  import write_fifo_pkg::*;
  import read_fifo_pkg::*;
  import axi4_slave_pkg::*;
  import axi_env_pkg::*;

  
  //Include all other files
  `include "fifo_bfm_base_test.sv"
  /*
  `include "axi_burst_type_test.sv"
  `include "axi_handshaking_test.sv"
  `include "fifo_bfm_empty_test.sv"
  `include "fifo_bfm_full_test.sv"
  `include "fifo_bfm_rd_test.sv"
  `include "fifo_bfm_read_empty_test.sv"
  `include "fifo_bfm_reset_test.sv"
  `include "fifo_bfm_write_full_test.sv"
  `include "fifo_bfm_wr_rd_test.sv"
  `include "fifo_bfm_wr_test.sv"
*/
endpackage : test_pkg

`endif

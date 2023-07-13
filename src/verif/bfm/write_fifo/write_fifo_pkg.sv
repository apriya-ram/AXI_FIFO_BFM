`ifndef WRITE_FIFO_PKG_INCLUDED_
`define WRITE_FIFO_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: axi4_env_pkg
// Includes all the files related to axi4 env
//--------------------------------------------------------------------------------------------
package write_fifo_pkg;
  
  //Import uvm package
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_globals_pkg::*;
  
  //Include all other files
  `include "write_fifo_seq_item.sv"
  `include "fifo_bfm_base_seq.sv"
  /*
  `include "axi_burst_type_seq.sv"
  `include "axi_handshaking_seq.sv"
  `include "fifo_bfm_empty_seq.sv"
  `include "fifo_bfm_full_seq.sv"
  `include "fifo_bfm_rd_seq.sv"
  `include "fifo_bfm_read_empty_seq.sv"
  `include "fifo_bfm_reset_seq.sv"
  `include "fifo_bfm_write_full_seq.sv"
  `include "fifo_bfm_wr_rd_seq.sv"
  `include "fifo_bfm_wr_seq.sv"
  */
  `include "write_sequencer.sv"
  `include "write_driver.sv"
  `include "write_monitor.sv"
  `include "write_agent.sv"

endpackage : write_fifo_pkg

`endif

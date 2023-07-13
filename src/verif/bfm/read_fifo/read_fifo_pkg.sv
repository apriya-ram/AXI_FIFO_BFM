`ifndef READ_FIFO_PKG_INCLUDED_
`define READ_FIFO_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: axi4_env_pkg
// Includes all the files related to axi4 env
//--------------------------------------------------------------------------------------------
package read_fifo_pkg;
  
  //Import uvm package
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_globals_pkg::*;

  import write_fifo_pkg::*;

  `include "read_fifo_monitor.sv"
  `include "read_agent.sv"

endpackage : read_fifo_pkg

`endif

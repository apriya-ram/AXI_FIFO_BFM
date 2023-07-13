`ifndef AXI_ENV_PKG_INCLUDED_
`define AXI_ENV_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: axi4_env_pkg
// Includes all the files related to axi4 env
//--------------------------------------------------------------------------------------------
package axi_env_pkg;
  
  //Import uvm package
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_globals_pkg::*;
  import write_fifo_pkg::*;
  import read_fifo_pkg::*;
  import axi4_slave_pkg::*;

  `include "axi_env.sv"
  //`include "fifo_scoreboard.sv"

endpackage : axi_env_pkg

`endif

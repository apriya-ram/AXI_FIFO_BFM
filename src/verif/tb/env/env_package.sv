`ifndef ENV_PACKAGE_INCLUDED_
`define ENV_PACKAGE_INCLUDED_

package env_package;
`include "uvm_macros.svh"
import uvm_pkg::*;
import axi4_globals_pkg::*;
import write_fifo_pkg::*;
import axi4_slave_pkg::*;
`include "axi_fifo_scoreboard.sv"
`include "env.sv"

endpackage
`endif



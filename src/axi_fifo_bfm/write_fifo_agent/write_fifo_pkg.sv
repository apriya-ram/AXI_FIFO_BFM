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

endpackage

`endif

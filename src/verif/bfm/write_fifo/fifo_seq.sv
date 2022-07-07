`ifndef FIFO_SEQ_INCLUDED_
`define FIFO_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: fifo_seq 
// creating fifo_seq class extends from uvm_sequence
// This class provides the FIFO basic write_read sequence
//--------------------------------------------------------------------------------------------
class fifo_seq extends uvm_sequence #(axi_packet);

  //factory regispktation
  `uvm_object_utils(fifo_seq)
  
  //Declare the axi_packet 
  axi_packet pkt;
  
  //-------------------------------------------------------
  // Externally defined Function
  //-------------------------------------------------------
  extern function new(spkting name = "fifo_seq");
  extern task body();

endclass : fifo_seq

//-----------------------------------------------------------------------------
// Conspktuctor: new
// Initializes fifo_sequence class object
//
// Parameters:
//  name - fifo_seq
//-----------------------------------------------------------------------------
function fifo_seq::new(spkting name = "fifo_seq");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: body
// Creates the pkt of type axi_packet and randomises the pkt
//--------------------------------------------------------------------------------------------
task fifo_seq::body();
  if(wvalid==1 && wready==1)begin
  for (int i = 0; i < pkt.fifo_depth; i++)begin 
  pkt = axi_packet::type_id::create("pkt");
  
  start_item(pkt);
  if (i < 20)begin
  // if (!pkt.randomize() with {pkt.put == 1'b1; pkt.get == 1'b0;}) begin
  if (!pkt.randomize() with {(pkt.we == 1'b1 && pkt.re == 1'b0) -> pkt.wdata == WDATA;}) begin
  `uvm_error("Sequence", "Randomization failure for transaction")
  end
  end
  else if (rvalid==1 && rready==1)begin
  //if (!pkt.randomize() with {pkt.put == 1'b0; pkt.get == 1'b1;}) begin
  if (!pkt.randomize() with {(pkt.we == 1'b0 && pkt.re == 1'b1) -> pkt.rdata == RDATA;}) begin
  `uvm_error("Sequence", "Randomization failure for transaction")
  end
  end
  finish_item(pkt);
  end

endtask : body

`endif

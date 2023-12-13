`ifndef FIFO_BFM_32B_RD_INCR_ALLIGNED_SEQUENCE_ARLEN_0_INCLUDED_
`define FIFO_BFM_32B_RD_INCR_ALLIGNED_SEQUENCE_ARLEN_0_INCLUDED_

class fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0 extends base_sequence;

 // bit[31:0] wdata_seq[$];
  bit[3:0] arlenn;
  bit [31:0] addr;
  //bit[3:0] wstrbb;
  bit[1:0] arburstt;
  bit[2:0] arsizee;

  `uvm_object_utils(fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0)

  function new(string name="fifo_bfm_32b_rd_incr_alligned_sequence_arlen_0");
    super.new(name);
  endfunction

  virtual task body(); 
    begin
      write_fifo_seq_item req;
      req=write_fifo_seq_item::type_id::create("req");
      repeat(1) begin
        start_item(req);
    $display("john address in sequence=%h",addr);
    $display("john arlen in sequence=%h",arlenn);
   // $display("john wstrb in sequence=%h",wstrbb);
    $display("john arburst in sequence=%h",arburstt);
    $display("john arsize in sequence=%h",arsizee);
   // $display("john wdata_seq in sequence=%p",wdata_seq);
    //$display("john wdata_seq size in sequence=%d",wdata_seq.size());
        assert(req.randomize() with {req.type_of_pkt==1 && req.araddr==addr && req.arlen==arlenn && req.arburst==arburstt && req.arsize==arsizee;});
      finish_item(req);
    end
   end
  endtask
  

endclass
`endif

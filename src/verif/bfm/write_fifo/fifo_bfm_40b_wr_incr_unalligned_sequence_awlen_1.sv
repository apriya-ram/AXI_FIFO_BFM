`ifndef FIFO_BFM_40B_WR_INCR_UNALLIGNED_SEQUENCE_AWLEN_1_INCLUDED_
`define FIFO_BFM_40B_WR_INCR_UNALLIGNED_SEQUENCE_AWLEN_1_INCLUDED_

class fifo_bfm_40b_wr_incr_unalligned_sequence_awlen_1 extends base_sequence;

  bit[31:0] wdata_seq[$];
  bit[3:0] awlenn;
  bit [31:0] addr;
  bit[3:0] wstrbb;
  bit[1:0] awburstt;
  bit[2:0] awsizee;

  `uvm_object_utils(fifo_bfm_40b_wr_incr_unalligned_sequence_awlen_1)

  function new(string name="fifo_bfm_40b_wr_incr_unalligned_sequence_awlen_1");
    super.new(name);
  endfunction

  virtual task body(); 
    begin
      write_fifo_seq_item req;
      req=write_fifo_seq_item::type_id::create("req");
      repeat(1) begin
        start_item(req);
    $display("john address in sequence=%h",addr);
    $display("john awlen in sequence=%h",awlenn);
    $display("john wstrb in sequence=%h",wstrbb);
    $display("john awburst in sequence=%h",awburstt);
    $display("john awsize in sequence=%h",awsizee);
    $display("john wdata_seq in sequence=%p",wdata_seq);
    $display("john wdata_seq size in sequence=%d",wdata_seq.size());
        assert(req.randomize() with {req.type_of_pkt==0 && req.awaddr==addr && req.wstrb==wstrbb && req.awlen==awlenn && req.awburst==awburstt && req.awsize==awsizee; foreach(req.wdata[i])
        {req.wdata[i]==wdata_seq[i];}});
      finish_item(req);
    end
   end
  endtask
  

endclass
`endif

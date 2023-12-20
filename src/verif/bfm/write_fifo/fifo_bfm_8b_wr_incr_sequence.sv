`ifndef FIFO_BFM_8B_WR_INCR_SEQUENCE_INCLUDED_
`define FIFO_BFM_8B_WR_INCR_SEQUENCE_INCLUDED_


class fifo_bfm_8b_wr_incr_sequence extends base_sequence;

  `uvm_object_utils(fifo_bfm_8b_wr_incr_sequence)

  function new(string name="fifo_bfm_8b_wr_incr_sequence");
    super.new(name);
  endfunction

  virtual task body(); 
    begin
      write_fifo_seq_item req;
      req=write_fifo_seq_item::type_id::create("req");
      repeat(1) begin
        start_item(req);
          assert(req.randomize() with {req.type_of_pkt==write_addr_phase_pkt && req.awlen==1;req.wstrb==4'b1000;req.awburst==2'b01;}); 
        finish_item(req);
      end
    end
  endtask

endclass
`endif

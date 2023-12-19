`ifndef WRITE_FIFO_SEQUENCE_INCLUDED_
`define WRITE_FIFO_SEQUENCE_INCLUDED_

class write_fifo_sequence extends base_sequence;

  `uvm_object_utils(write_fifo_sequence)
   write_fifo_seq_item req;
   
  function new(string name = "write_fifo_sequence");
    super.new(name);
  endfunction

  virtual task body();
    req = write_fifo_seq_item :: type_id :: create("req");
    `uvm_info(get_type_name(),"Inside body of write_fifo_sequence",UVM_DEFAULT)
    repeat(1)begin
      start_item(req);
      assert(req.randomize() with {req.type_of_pkt==0;req.awlen==1;});
      finish_item(req);
    end
  endtask

endclass


`endif

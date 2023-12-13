`ifndef READ_FIFO_SEQ_ITEM_INCLUDED_
`define READ_FIFO_SEQ_ITEM_INCLUDED_ 


class read_fifo_seq_item extends uvm_sequence_item;

  bit[7:0] sop;
  bit[7:0] eop;

  rid_e rid;
  bit[DATA_WIDTH:0] rdata[$];
  rresp_e rresp;

  bid_e bid;
  bresp_e bresp;


  `uvm_object_param_utils_begin(read_response_pkt_seq_item)
    `uvm_field_enum(bid_e,bid,UVM_ALL_ON)
    `uvm_field_enum(bresp_e,bresp,UVM_ALL_ON)
    `uvm_field_enum(rid_e,rid,UVM_ALL_ON)
    `uvm_field_queue_int(rdata,UVM_ALL_ON)
    `uvm_field_enum(rresp_e_e,rresp,UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name="read_fifo_seq_item");
    super.new(name);
  endfunction


endclass

`endif

class fifo_seq extends uvm_sequence
	'uvm_object_utils(fifo_sequence)

 data_transaction tr;

 function new(string name = "fifo_sequence");

  super.new(name);

 endfunction

 task body();

  tr = data_transaction::type_id::create("tx_data_tr");

  start_item(tr);

   for (int i = 0; i < tr.Fifo_depth; i++)

   begin

   if(tr.wvalid==1 && tr.wready==1)

   begin

   if (!tr.randomize() with {(tr.we == 1'b1 && tr.re == 1'b0) -> tr.wdata == WDATA;})

       `uvm_error("Sequence", "Randomization failure for trasaction")

   end

  else if (rvalid==1 && rready==1)

  begin

  if (!tr.randomize() with {(tr.we == 1'b0 && tr.re == 1'b1) -> tr.radata == RDATA;})

     `uvm_error("Sequence", "Randomization failure for trasaction")

  end

  end

  finish_item(tr);

  endtask

endclass : fifo_sequence

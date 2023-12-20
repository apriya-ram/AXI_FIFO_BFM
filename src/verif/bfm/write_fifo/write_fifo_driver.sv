`ifndef WRITE_FIFO_DRIVER_INCLUDED_
`define WRITE_FIFO_DRIVER_INCLUDED_

class write_fifo_driver extends uvm_driver#(write_fifo_seq_item);

  function new(string name="write_fifo_driver",uvm_component parent= null);
      super.new(name,parent);
  endfunction
  
  `uvm_component_utils(write_fifo_driver)
   
  write_fifo_seq_item write_fifo_seq_item_h;
  virtual fifo_if fintf;

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    wait_for_reset();
    write_fifo_seq_item_h=write_fifo_seq_item::type_id::create("write_fifo_seq_item");
    forever begin 
    seq_item_port.get_next_item(write_fifo_seq_item_h);
    write_fifo_seq_item_h.print(); 
    if(write_fifo_seq_item_h.type_of_pkt==0)begin
      $display("JOHN_WRITE IN IF");
      write_drive_pkt(write_fifo_seq_item_h);
    end
    else begin
      $display("JOHN_READ IN ELSE");
        read_drive_pkt(write_fifo_seq_item_h);
      end
      @(posedge(fintf.clk));
        fintf.wr_en <=0;
        seq_item_port.item_done();
      end

  endtask

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual fifo_if)::get(this,"","vif",fintf);
  endfunction

  task wait_for_reset();
    @(negedge(fintf.rstn));
      fintf.wr_en <=0;
      fintf.wr_data <=0;

      @(posedge(fintf.rstn));
  endtask

  task read_drive_pkt(write_fifo_seq_item write_fifo_seq_item_h);
    bit [127:0] read_pkt;
  //  write_fifo_seq_item_h.arid=ARID_2;

    read_pkt = {write_fifo_seq_item_h.SOP,
                write_fifo_seq_item_h.arid,
                write_fifo_seq_item_h.araddr,
                write_fifo_seq_item_h.arlen,
                write_fifo_seq_item_h.arsize,
                write_fifo_seq_item_h.arburst,
                write_fifo_seq_item_h.arlock,
                write_fifo_seq_item_h.arcache,
                write_fifo_seq_item_h.arprot,
                4'hf,
                8'h0,
                write_fifo_seq_item_h.EOP,
                48'h0};
        $display("JOHN_READ_PKT=%0h",read_pkt);
        $display("JOHN_arid=%b", write_fifo_seq_item_h.arid);


      `uvm_info(get_type_name,"waiting for FIFO is not full in read_drive_pkt task", UVM_NONE)
      @(posedge(fintf.clk));
      wait(!(fintf.full));
        fintf.wr_en <=1;
        $display("JOHN_READ_PKT=%0b",read_pkt);
        //read_pkt=128'haa1bbbbbbbb1480f0053000000000000;
       // read_pkt=128'h5535358011011c03c014c00000000000;
        $display("JOHN_READ_PKT=%0h",read_pkt);
        $display("JOHN_READ_PKT=%0b",read_pkt);
        fintf.wr_data <= read_pkt;
      `uvm_info(get_type_name,"Sent read packet", UVM_NONE) 

  endtask


  task write_drive_pkt(write_fifo_seq_item write_fifo_seq_item_h);
    bit[1151:0]duplicate_eop;
    bit [1151:0] total_pkt;
    bit [1023:0]wdata;
    int no_of_pkt;
    bit [7:0] q[$];
    int no_of_bits_in_queue;

        if(write_fifo_seq_item_h.wstrb == 4'b0001)
	   //q[0] = write_fifo_seq_item_h.wdata[0][7:0];
	   q.push_back(write_fifo_seq_item_h.wdata[0][7:0]);
	else if(write_fifo_seq_item_h.wstrb == 4'b0011)
	begin
	   q.push_back(write_fifo_seq_item_h.wdata[0][15:8]);
	   q.push_back(write_fifo_seq_item_h.wdata[0][7:0]);
	end
	else if(write_fifo_seq_item_h.wstrb == 4'b0111)
	begin
	   q.push_back(write_fifo_seq_item_h.wdata[0][23:16]);
	   q.push_back(write_fifo_seq_item_h.wdata[0][15:8]);
	   q.push_back(write_fifo_seq_item_h.wdata[0][7:0]);
	end
	else if(write_fifo_seq_item_h.wstrb == 4'b1111)
	begin
	   q.push_back(write_fifo_seq_item_h.wdata[0][31:24]);
	   q.push_back(write_fifo_seq_item_h.wdata[0][23:16]);
	   q.push_back(write_fifo_seq_item_h.wdata[0][15:8]);
	   q.push_back(write_fifo_seq_item_h.wdata[0][7:0]);
	end

  
	foreach(write_fifo_seq_item_h.wdata[i])
	begin
	  if(i>0)
	   begin
	     for(int j =0; j<4;j++)
		begin
		  q.push_back(write_fifo_seq_item_h.wdata[i][31-(8*j)-:8]);
		end
	   end
	end

        no_of_bits_in_queue = q.size()*8; //calculating no. of bits in burst
       // $display("vinay: data in queue: %p",q);
        $display("shahid: no of bits in queue: %d",no_of_bits_in_queue);       
        
	//concatenating the elements in the wdata queue in one variable bit[1023:0]wdata
        //Ex: bit[1024:0] wdata = 0000...wdata;  000 32wdata;
	foreach(q[i]) begin
          wdata = {wdata,q[i]};
        end
  //  foreach(write_fifo_seq_item_h.wdata[i])begin
    //  wdata = {wdata,write_fifo_seq_item_h.wdata[i]};
   // end

      wdata = wdata <<  (1024-(no_of_bits_in_queue));
      
     /* `uvm_info(get_type_name,$sformatf("before shift,wdata=%h",wdata), UVM_NONE)
      wdata = wdata << 1024 -((write_fifo_seq_item_h.wdata.size())*DATA_WIDTH);
      `uvm_info(get_type_name,$sformatf("after shift,wdata=%h",wdata), UVM_NONE)
      `uvm_info(get_type_name,$sformatf("SOP=%h",write_fifo_seq_item_h.SOP), UVM_NONE)*/
      

      total_pkt = {write_fifo_seq_item_h.SOP,
                   write_fifo_seq_item_h.awid,
                   write_fifo_seq_item_h.awaddr,
                   write_fifo_seq_item_h.awlen,
                   write_fifo_seq_item_h.awsize,
                   write_fifo_seq_item_h.awburst,
                   write_fifo_seq_item_h.awlock,
                   write_fifo_seq_item_h.awcache,
                   write_fifo_seq_item_h.awprot,
                   write_fifo_seq_item_h.wstrb,
                   wdata,
                   64'b0};
     // `uvm_info(get_type_name,$sformatf("after concetinantion,total pkt=%h",total_pkt), UVM_NONE)

      duplicate_eop = write_fifo_seq_item_h.EOP;
   //   `uvm_info(get_type_name,$sformatf("before shift,dup_eop =%h",duplicate_eop), UVM_NONE)
      duplicate_eop = duplicate_eop << 1152 - (64+no_of_bits_in_queue) - 8;
    //  `uvm_info(get_type_name,$sformatf("after shift,dup_eop =%h",duplicate_eop), UVM_NONE)

      total_pkt = total_pkt + duplicate_eop;
  //    `uvm_info(get_type_name,$sformatf("after adding dup_eop,total pkt=%h",total_pkt), UVM_NONE)


      if(no_of_bits_in_queue<=56)begin
           `uvm_info(get_full_name(),"WAITING FOR WRITE FIFO NOT FULL WHILE DRIVING WRITE PHASE PKT OF WDATA BITS LESS THAN 56",UVM_HIGH)
            wait(!(fintf.full));
            @(posedge(fintf.clk));
            fintf.wr_en <= 1;
        fintf.wr_data <= total_pkt[1151-: 128];
    //    `uvm_info(get_type_name,$sformatf("less than 56,wr_data=%h",total_pkt[1151-: 128]), UVM_NONE)
            `uvm_info(get_full_name(),$sformatf("Final packet driven into DUT : %h",total_pkt[1151-:128]),UVM_NONE);
      end

    else if(no_of_bits_in_queue>56)begin

      if((64 + 8 + no_of_bits_in_queue)%128==0)
        no_of_pkt = (64 + 8 + no_of_bits_in_queue)/128;
        else
          no_of_pkt = (64 + 8 + no_of_bits_in_queue)/128 + 1;

        end

          for(int i =0;i <no_of_pkt;i++)begin

            `uvm_info(get_type_name,"waiting for FIFO is not full in write_drive_pkt task", UVM_NONE)
            wait(!(fintf.full));
            @(posedge(fintf.clk));
            fintf.wr_en <= 1;
            fintf.wr_data <= total_pkt[1151 - (128 * i)-: 128];
           // `uvm_info(get_type_name,$sformatf("greater than 56, wr_data=%h",total_pkt[1151 - (128 * i)-: 128]), UVM_NONE)
            `uvm_info(get_full_name(),$sformatf("Final packet driven into DUT : %h",total_pkt[1151-(128*i)-:128]),UVM_NONE);
          end
          

  endtask

endclass
`endif
  

    


  

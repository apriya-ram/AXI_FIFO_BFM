`ifndef WRITE_FIFO_MONITOR_INCLUDED_
`define WRITE_FIFO_MONITOR_INCLUDED_

class write_fifo_monitor extends uvm_component;
  `uvm_component_utils(write_fifo_monitor)

  virtual fifo_if fintf;

  //Viable write_fifo_seq_item_h
  //Instantiating a sequence item packet
  //write_fifo_seq_item write_fifo_seq_item_h;
  write_fifo_seq_item write_fifo_seq_item_h;

  uvm_analysis_port #(write_fifo_seq_item)item_collected_port;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "write_fifo_monitor", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  //extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  //extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : write_fifo_monitor

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - write_fifo_monitor
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function write_fifo_monitor::new(string name = "write_fifo_monitor",
  uvm_component parent = null);
  super.new(name, parent);
  item_collected_port=new("item_collected_port",this);

endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void write_fifo_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual fifo_if)::get(this,"","vif",fintf))
    `uvm_info(get_full_name(),"VIRTUAL INTERFACE DIDN'T GET IN MONITOR",UVM_NONE)

  endfunction : build_phase

  //--------------------------------------------------------------------------------------------
  // Function: connect_phase
  // <Description_here>
  //
  // Parameters:
  //  phase - uvm phase
  //--------------------------------------------------------------------------------------------
  function void write_fifo_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase

  //--------------------------------------------------------------------------------------------
  // Task: run_phase
  // <Description_here>
  //
  // Parameters:
  //  phase - uvm phase
  //--------------------------------------------------------------------------------------------
  task write_fifo_monitor::run_phase(uvm_phase phase);

 //   int i=0 ;
 //   int k=0;
 //   int V=0;
 //   int j=0;
 //   int t=i;
    int strb_cnt = 0; //
    int no_of_bits = 0;
    int no_of_elements_in_queue = 0;
    int no_of_bits_remaining = 0;
    int no_of_iters = 0;
    int no_of_8s_remaining = 0;
    bit[7:0] byte_queue[$];
    int wdata_32 = 0;
    int no_of_32s = 0;
    super.run_phase(phase);
    $display("monitor started");

    @(negedge(fintf.rstn));
    `uvm_info(get_full_name(), $sformatf("system reset detected"), UVM_HIGH)
    @(posedge(fintf.rstn));
    `uvm_info(get_full_name(), $sformatf("system reset deactivated"), UVM_HIGH)

    forever begin
    write_fifo_seq_item_h=write_fifo_seq_item::type_id::create("write_fifo_seq_item_h");
      @(posedge(fintf.clk));
      while(fintf.wr_en!==1)
        @(posedge(fintf.clk));
      if(fintf.wr_data[127:120]==8'b10101010 && fintf.wr_data[63:56]==8'b0 && fintf.wr_data[55:48]==8'b01010011)//read write_fifo_seq_item_h 
      begin 
        $cast(write_fifo_seq_item_h.arid,fintf.wr_data[119 -:4]);
        write_fifo_seq_item_h.araddr=fintf.wr_data[115 -:32];
        write_fifo_seq_item_h.arlen=fintf.wr_data[83 -:4];
       $cast( write_fifo_seq_item_h.arsize,fintf.wr_data[79 -:3]);
       $cast( write_fifo_seq_item_h.arburst,fintf.wr_data[76 -:2]);
       $cast( write_fifo_seq_item_h.arlock,fintf.wr_data[74 -:2]);
       $cast( write_fifo_seq_item_h.arcache,fintf.wr_data[72-:2]);
       $cast( write_fifo_seq_item_h.arprot,fintf.wr_data[70 -:3]);
        write_fifo_seq_item_h.wstrb=fintf.wr_data[67-:4];
    
      $cast(write_fifo_seq_item_h.type_of_pkt,1);
      item_collected_port.write(write_fifo_seq_item_h);
      write_fifo_seq_item_h.print();
      $display("Tharun Monitor received the data %t",$time);
      end
    if(fintf.wr_data[127:120]==8'b10101010) 
      begin
       $cast(write_fifo_seq_item_h.awid,fintf.wr_data[119 -:4]);
        write_fifo_seq_item_h.awaddr=fintf.wr_data[115 -:32];
        write_fifo_seq_item_h.awlen=fintf.wr_data[83 -:4];
       $cast( write_fifo_seq_item_h.awsize,fintf.wr_data[79 -:3]);
       $cast( write_fifo_seq_item_h.awburst,fintf.wr_data[76 -:2]);
       $cast( write_fifo_seq_item_h.awlock,fintf.wr_data[74 -:2]);
       $cast( write_fifo_seq_item_h.awcache,fintf.wr_data[72-:2]);
       $cast( write_fifo_seq_item_h.awprot,fintf.wr_data[70 -:3]);
        write_fifo_seq_item_h.wstrb=fintf.wr_data[67-:4];


       strb_cnt = $countones(write_fifo_seq_item_h.wstrb);
       no_of_bits = write_fifo_seq_item_h.awlen*32+(8*strb_cnt);
       no_of_elements_in_queue = no_of_bits/8;
       if(no_of_elements_in_queue<=8) begin
         for(int a=0; a<no_of_elements_in_queue; a++) begin
            byte_queue.push_back(fintf.wr_data[63-8*a -: 8]);
         end
       end
//max=awlen 15, total 32's are  16
//eop
       if(no_of_elements_in_queue>8) begin
          for(int b=0; b<8; b++) begin
            byte_queue.push_back(fintf.wr_data[63-8*b -: 8]);
          end

//remaing bits apart from 64 32 32 
          no_of_bits_remaining = (no_of_elements_in_queue-8)*8;
          if(no_of_bits_remaining%128==0) begin

// how many 128 bits are remaining         
            no_of_iters = no_of_bits_remaining/128;
          end
          else begin
            //if not divisible by 128 ,
            no_of_iters = (no_of_bits_remaining/128);
            //no of bits remaing after aprox divisible by 128
            no_of_8s_remaining = (no_of_bits_remaining - (no_of_bits_remaining/128)*128)/8;
          end
    
          for(int c=0; c<no_of_iters; c++) begin
            @(posedge(fintf.clk));
            while(!fintf.wr_en) begin
              @(posedge(fintf.clk));
            end
//per one transfer we need to transfer 16 8's(128 bits) so pushing remaining bits 
            for(int d=0; d<16; d++) begin
              byte_queue.push_back(fintf.wr_data[127-8*d -: 8]);
            end

          end

          if(no_of_8s_remaining>0) begin
            @(posedge(fintf.clk));
            while(!fintf.wr_en) begin
              @(posedge(fintf.clk));
            end
//push remaining 8's             
            for(int e=0; e<no_of_8s_remaining; e++) begin
              byte_queue.push_back(fintf.wr_data[127-8*e -: 8]);
            end
          end
          //else for............ if EOP is [127:120]
          else begin
            @(posedge(fintf.clk));
          end
      end
//////////entire W_DATA  transfered in 8 bits format  

//WE NEED 32 BIT SO, WE NEED TO CONCOTINATE 
     for(int f=0; f<strb_cnt; f++) begin
        wdata_32 = {wdata_32,byte_queue.pop_front()};
     end

    
     // wdata_32 = wdata_32 << (32-8*strb_cnt);
     // assigning W_data to write_fifo_seq_item_h for 1st transfer strobe
    write_fifo_seq_item_h.wdata.push_back(wdata_32);

     no_of_32s = (byte_queue.size()*8)/32;

     for(int g=0;g<no_of_32s; g++) begin
        wdata_32 = 0;
        for(int h=0;h<4;h++) begin
          wdata_32 = {wdata_32,byte_queue.pop_front()};
        end
        write_fifo_seq_item_h.wdata.push_back(wdata_32);
     end
      $cast(write_fifo_seq_item_h.type_of_pkt,0);
      item_collected_port.write(write_fifo_seq_item_h);
      write_fifo_seq_item_h.print();
      $display("Tharun Monitor received the data");
      
  
  //  i=0;
  //  k=0;
  //  V=0;
  //  j=0;
  //  t=0;
    end
    strb_cnt = 0; //
    no_of_bits = 0;
    no_of_elements_in_queue = 0;
    no_of_bits_remaining = 0;
    no_of_iters = 0;
    no_of_8s_remaining = 0;
    byte_queue.delete();
    wdata_32 = 0;
    no_of_32s = 0;
  end
    endtask : run_phase

  `endif


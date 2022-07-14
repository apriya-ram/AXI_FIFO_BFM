`ifndef READ_FIFO_MONITOR_INCLUDED_
`define READ_FIFO_MONITOR_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: read_fifo_monitor
// <Description_here>
//--------------------------------------------------------------------------------------------
class read_fifo_monitor extends uvm_component;
  `uvm_component_utils(read_fifo_monitor)
  
  //variable :cgf_h
  //Declaring the read agent

  fifo_seq_item pkt1;

  virtual fifo_interface intf;

  uvm_analysis_port #(fifo_seq_item)item_collected_port1;

  function new(string name="read_fifo_monitor",uvm_component parent);
     super.new(name,parent);

    item_collected_port1=new("item_collected_port1",this);

endfunction

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "read_fifo_monitor", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : read_fifo_monitor
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual fintf)::get(this, "", "vif", intf);
  endfunction


   task run_phase(uvm_phase phase);
     pkt1=fifo_seq_item::type_id::create("pkt1");

    // @(posedge intf.clk);
    // @(posedge intf.clk);

     forever begin
       @(posedge intf.clk);

       pkt1.wr<=intf.wr;
       pkt1.rd<=intf.rd;

       pkt1.data_out<=intf.data_out;
       pkt1.fifo_cnt<=intf.fifo_cnt;
       pkt1.empty<=intf.empty;
       pkt1.full<=intf.full;
       pkt1.display("MONITOR_2");

       item_collected_port1.write(pkt1);


       end
       endtask
 endclass


`endif


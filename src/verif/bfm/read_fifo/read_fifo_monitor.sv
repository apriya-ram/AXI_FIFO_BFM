`ifndef READ_FIFO_MONITOR_INCLUDED_
`define READ_FIFO_MONITOR_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: read_fifo_monitor
// <Description_here>
//--------------------------------------------------------------------------------------------

class read_fifo_monitor extends uvm_monitor;
  `uvm_component_utils(read_fifo_monitor)
  
  //variable :cgf_h
  //Declaring the read agent

  fifo_sequence_item pkt1;

  virtual fifo_if intf;

  uvm_analysis_port #(fifo_sequence_item)item_collected_port1;

  function new(string name="read_fifo_monitor",uvm_component parent);
     super.new(name,parent);

    item_collected_port1=new("item_collected_port1",this);

endfunction

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  //extern function new(string name = "read_fifo_monitor", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : read_fifo_monitor
  
  function void read_fifo_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual fifo_if)::get(this, "", "vif", intf);
  endfunction


   task read_fifo_monitor::run_phase(uvm_phase phase);
     pkt1=fifo_sequence_item#()::type_id::create("pkt1");

    // @(posedge intf.clk);
    // @(posedge intf.clk);

     forever begin
       @(posedge intf.clk);
  /*
       pkt1.wr<=intf.wr_en;
       pkt1.rd<=intf.rd_en;

       pkt1.data_out<=intf.rd_data;
       //pkt1.fifo_cnt<=intf.fifo_cnt;
       pkt1.empty<=intf.empty;
       pkt1.full<=intf.full;
       */
       $display("MONITOR_2");

       item_collected_port1.write(pkt1);


       end
    endtask : run_phase

`endif


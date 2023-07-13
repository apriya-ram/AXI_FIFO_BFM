`ifndef FIFO_BFM_MONITOR_INCLUDED_
`define FIFO_BFM_MONITOR_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: fifo_bfm_monitor
// <Description_here>
//--------------------------------------------------------------------------------------------
class fifo_bfm_monitor extends uvm_component;
  `uvm_component_utils(fifo_bfm_monitor)

   //variable intf
   //Defining virtual interface
   virtual fifo_if intf;

   //variable pkt
   //Instantiating a sequence item packet
   fifo_sequence_item pkt;

   uvm_analysis_port #(fifo_sequence_item)item_collected_port;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "fifo_bfm_monitor", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  //extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  //extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : fifo_bfm_monitor

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - fifo_bfm_monitor
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function fifo_bfm_monitor::new(string name = "fifo_bfm_monitor",
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
function void fifo_bfm_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uvm_config_db#(virtual fifo_if)::get(this,"","vif",intf);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void fifo_bfm_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task fifo_bfm_monitor::run_phase(uvm_phase phase);

  super.run_phase(phase);
  pkt=fifo_sequence_item#()::type_id::create("pkt");
  @(posedge intf.clk);
  forever begin
  @(posedge intf.clk);
  /*
  pkt.wr<=intf.wr_en;
  pkt.rd<=intf.rd_en;
  pkt.data_in<=intf.wr_data;
  */
  item_collected_port.write(pkt);
  $display("Monitor received the data");
  end

endtask : run_phase

`endif


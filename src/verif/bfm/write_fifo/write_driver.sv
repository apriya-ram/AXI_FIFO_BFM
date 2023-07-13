`ifndef WRITE_FIFO_DRIVER_INCLUDED_
`define WRITE_FIFO_DRIVER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: write_fifo_driver
// <Description_here>
//--------------------------------------------------------------------------------------------
class write_fifo_driver extends uvm_driver#(fifo_sequence_item);
  `uvm_component_utils(write_fifo_driver)

  //variable intf
  //DEfining virtual interface
  virtual fifo_if intf;

  //variable pkt
  //Declaring sequence item handle
  fifo_sequence_item pkt;

  bit[127:0] queue0[$];
  bit[127:0] queue1[$];
  bit[127:0] queue2[$];
  bit[127:0] queue3[$];
  bit[127:0] queue4[$];

  bit [1023:0] packet;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "write_fifo_driver", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task drive(fifo_sequence_item pkt);
endclass : write_fifo_driver

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - write_fifo_driver
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function write_fifo_driver::new(string name = "write_fifo_driver",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void write_fifo_driver::build_phase(uvm_phase phase);
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
function void write_fifo_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

  task write_fifo_driver::reset();
    wait(!intf.rst);
    intf.wr_data<=0;
    intf.wr_en<=0;
    intf.rd_en<=0;
    wait(intf.rst);
  endtask

//--------------------------------------------------------------------------------------------
// Task: run_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task write_fifo_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);

    reset();
      forever begin
      pkt=fifo_sequence_item#()::type_id::create("pkt");
      seq_item_port.get_next_item(pkt);
      drive(pkt);
      seq_item_port.item_done();
      $display("DRIVER");
    end
  endtask : run_phase

  

  task write_fifo_driver::drive(fifo_sequence_item pkt);
    
    @(posedge intf.clk);
    intf.wr_en<=1;
    intf.rd_en<=1;
    //intf.data_in<=pkt.data_in;
    // Write Address Channel
    
    
    if(pkt.type_of_axi == 0) begin
      packet = {pkt.sop, pkt.type_of_axi, pkt.awid, pkt.awlen, pkt.awsize, pkt.awburst, pkt.awaddr , pkt.eop};
      queue0.push_back(pkt.awaddr);
    end

// Write Data Channel
if(pkt.type_of_axi == 1) begin
      packet = {pkt.sop, pkt.type_of_axi, pkt.wid, pkt.wstrb, pkt.wdata, pkt.wlast, pkt.eop};
        queue1.push_back(pkt.wdata);
        intf.wr_data <= queue1[0];
        queue1.pop_front();
      end

// Read Address Channel
if(pkt.type_of_axi == 2) begin
      packet = {pkt.sop, pkt.type_of_axi, pkt.arid, pkt.arlen, pkt.arsize, pkt.arburst, pkt.araddr, pkt.eop};
       queue2.push_back(pkt.araddr);
     end

// Read Data Channel
if(pkt.type_of_axi == 3) begin
     packet = {pkt.sop, pkt.type_of_axi, pkt.rid, pkt.rresp, pkt.rlast, pkt.rdata , pkt.eop};
      queue3.push_back(pkt.rdata);
    end
// Write Response Channel
if(pkt.type_of_axi == 4) begin
     packet = {pkt.sop, pkt.type_of_axi, pkt.bid, pkt.bresp, pkt.eop};
     queue4.push_back(pkt.bresp);
   end


endtask : drive

`endif


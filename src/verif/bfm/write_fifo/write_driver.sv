`ifndef WRITE_FIFO_DRIVER_INCLUDED_
`define WRITE_FIFO_DRIVER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: write_fifo_driver
// <Description_here>
//--------------------------------------------------------------------------------------------
class write_fifo_driver extends uvm_driver(write_fifo_seq_item;
  `uvm_component_utils(write_fifo_driver)

  //variable intf
  //DEfining virtual interface
  virtual fifo_if intf;

  //variable pkt
  //Declaring sequence item handle
  write_fifo_seq_item pkt;

  queue0 = [$];
  queue1 = [$];
  queue2 = [$];
  queue3 = [$];
  queue4 = [$];

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "write_fifo_driver", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task (string name="write_fifo_seq_item",uvm_object );
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

  task reset();
    wait(!intf.rst);
    intf.data_in<=0;
    intf.wr<=0;
    intf.rd<=0;
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

    reset();
      forever begin
      pkt=write_fifo_seq_item::type_id::create("pkt");
      seq_item_port.get_next_item(pkt);
      drive(pkt);
      seq_item_port.item_done();
      pkt.display("DRIVER");
    end
  endtask

  super.run_phase(phase);


  task drive(write_fifo_seq_item pkt);
    
    @(posedge intf.clk);
    intf.wr<=pkt.wr;
    intf.rd<=pkt.rd;
    //intf.data_in<=pkt.data_in;
    // Write Address Channel
    
    if(pkt.type_of_axi == 0)
      {packet = {pkt.sop, pkt.type_of_axi, pkt.awid, pkt.awlen, pkt.awsize, pkt.awburst, pkt.awaddr , pkt.eop};
      queue0.push_back(pkt.awaddr);
    }

// Write Data Channel
    if(pkt.type_of_axi == 1)
      {packet = {pkt.sop, pkt.type_of_axi, pkt.wid, pkt.wstrb, pkt.wdata, pkt.wlast, pkt.eop};
        queue1.push_back(pkt.wdata);
        intf.data_in <= queue1[0];
        queue1.popfront();
      }

// Read Address Channel
    if(pkt.type_of_axi == 2)
      {packet = {pkt.sop, pkt.type_of_axi, pkt.arid, pkt.arlen, pkt.arsize, pkt,arburst, pkt.araddr, pkt.eop};
       queue2.push_back(pkt.araddr);
        }

// Read Data Channel
   if(pkt.type_of_axi == 3)
     {packet = {pkt.sop, pkt.type_of_axi, pkt.rid, pkt.rresp, pkt.rlast, pkt.rdata , pkt.eop};
      queue3.push_back(pkt.rdata);
          }
// Write Response Channel
   if(pkt.type_of_axi == 4)
     {packet = {pkt.sop, pkt.type_of_axi, pkt.bid, pkt.bresp, pkt.eop};
     queue4.push_back(pkt.bresp);}


endtask : run_phase

`endif


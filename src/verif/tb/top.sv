`ifndef TOP_INCLUDED_
`define TOP_INCLUDED_

//--------------------------------------------------------------------------------------------
// Module      : Top
// Description : Has a interface master and slave agent bfm.
//--------------------------------------------------------------------------------------------

`timescale 1ns / 1ps

module top;
 
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_globals_pkg::*;
  
  import write_fifo_pkg::*;
  import read_fifo_pkg::*;
  import axi4_slave_pkg::*;
  import axi_env_pkg::*;
  import test_pkg::*;
  
  //-------------------------------------------------------
  // Clock Reset Initialization
  //-------------------------------------------------------
  //giving as parameterised
  bit aclk;
  bit aresetn;
  int freq = 100;
  int t = 1000/freq;

  //-------------------------------------------------------
  // Display statement for HDL_TOP
  //-------------------------------------------------------
  initial begin
    $display("HDL_TOP");
  end

  //-------------------------------------------------------
  // System Clock Generation
  //-------------------------------------------------------
  initial begin
    aclk = 1'b0;
    forever #(t/2) aclk = ~aclk;
  end

  //-------------------------------------------------------
  // System Reset Generation
  // Active low reset
  //-------------------------------------------------------
  initial begin
    aresetn = 1'b1;
    #5 aresetn = 1'b0;

    repeat (1) begin
      @(posedge aclk);
    end
    aresetn = 1'b1;
  end

  // Variable : intf
  // axi4 Interface Instantiation
  axi4_if intf(.aclk(aclk), .aresetn(aresetn));

  fifo_if fintf(.clk(aclk), .rst(aresetn));

  //Dut instantiation
  //to-do parameters and fifo signals
  //giving same clk and reset to fifo and axi master
  //might be an error in fifo interface signals mapping, most probably in d_in and d_out
  
  Project_AXI4_Top project_axi4_top(

    //clk nd reset
      .clk(aclk),
      .rst(aresetn),
      .ACLK(aclk),
      .ARESETn(aresetn),

    //write address channel signals
      .AWID_a(intf.awid),
      .AWADDR_a(intf.awaddr),
      .AWLEN_a(intf.awlen),
      .AWSIZE_a(intf.awsize),
      .AWBURST_a(intf.awburst),
      .AWLOCK_a(intf.awlock),
      .AWCACHE_a(intf.awcache),
      .AWPROT_a(intf.awprot),
      .AWREADY_a(intf.awready),
      .AWVALID_a(intf.awvalid),

    //read address channel signals
      .ARID_a(intf.arid),
      .ARADDR_a(intf.araddr),
      .ARLEN_a(intf.arlen),
      .ARSIZE_a(intf.arsize),
      .ARBURST_a(intf.arburst),
      .ARLOCK_a(intf.arlock),
      .ARCACHE_a(intf.arcache),
      .ARPROT_a(intf.arprot),
      .ARVALID_a(intf.arvalid),
      .ARREADY_a(intf.arready),
    
    //write data channel signals
      //.WID_a(),
      .WDATA_a(intf.wdata),
      .WSTRB_a(intf.wstrb),
      .WLAST_a(intf.wlast),
      .WVALID_a(intf.wvalid),
      .WREADY_a(intf.wready),
  
    //read data channel signals
      .RREADY_a(intf.rready),
      .RID_a(intf.rid),
      .RDATA_a(intf.rdata),
      .RRESP_a(intf.rresp),
      .RLAST_a(intf.rlast),
      .RVALID_a(intf.rvalid),

    //write response channel
      .BID_a(intf.bid),
      .BRESP_a(intf.bresp),
      .BVALID_a(intf.bvalid),
      .BREADY_a(intf.bready),

    //read fifo signals
      .rd_data(fintf.rd_data),
      .empty(fintf.empty),
      .rd_en(fintf.rd_en),

    //write fifo signals
      .wr_en(fintf.wr_en),
      .wr_data(fintf.wr_data),
      .full(fintf.full)
  );

  initial begin
    //config db for write and read fifo
    uvm_config_db#(virtual fifo_if)::set(null,"*","vif",fintf);
    run_test("fifo_bfm_base_test");
  end

  //-------------------------------------------------------
  // AXI4  No of Master and Slaves Agent Instantiation
  //-------------------------------------------------------
  
  genvar i;
  generate
  /*
    for (i=0; i<NO_OF_MASTERS; i++) begin : axi4_master_agent_bfm
      axi4_master_agent_bfm #(.MASTER_ID(i)) axi4_master_agent_bfm_h(intf);
      defparam axi4_master_agent_bfm[i].axi4_master_agent_bfm_h.MASTER_ID = i;
    end
  */
 
    for (i=0; i<NO_OF_SLAVES; i++) begin
      axi4_slave_agent_bfm #(.SLAVE_ID(i)) axi4_slave_agent_bfm_h(intf);
      defparam axi4_slave_agent_bfm_h.SLAVE_ID = i;
      //axi4_slave_agent_bfm[i].
    end
  endgenerate
  
endmodule : top

`endif


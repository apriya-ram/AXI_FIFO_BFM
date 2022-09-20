`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company					:	  Mirafra Technologies	 
// Engineer					:    P Shankar sharama
// 
// Create Date				:    11:49:14 07/26/2022 
// Design Name				: 	  AXI4 Master 
// Module Name				:    AXI_Master_Top 
// Project Name			: 
// Target Devices			: 	  
// Tool versions			: 
// Description				: 
//
// Dependencies			: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module AXI_Master #(parameter  addr_width=32, 
                    parameter  data_width=64
						  )      ///////
						 (
						   /////////AXI Global signals clock and reset
                     input							AClk,
							input							ARst,
							
							/////////////AXI Write Address signals
							output	[7	:	0]								AWID,
							output	[addr_width-1	:	0]				AWADDR,
							output	[7	:	0]								AWLEN,
							output	[2	:	0]								AWSIZE,
							output	[1	:	0]								AWBURST,
							output											AWVALID,
							input												AWREADY,
							output	[1	:	0]								AWLOCK,
							output	[1	:	0]								AWCACHE,
							output	[2	:	0]								AWPROT,
							
							////////AXI Write Data channel signals
							output	[7	:	0]								WID,   
							output	[7	:	0]								WSTRB,
							output	[data_width-1	:	0]				WDATA,
							output											WLAST,
							output											WVALID,
							input												WREADY,
							
							/////////AXI Write Response  channel signals
							input		[3	:	0]								BID,
							input		[1	:	0]								BRESP,
							input												BVALID,
							output											BREADY,
							
							/////////AXI READ CHannel signals
							output	[7	:	0]								ARID,
							output	[addr_width-1	:	0]				ARADDR,
							output	[7	:	0]								ARLEN,
							output	[2	:	0]								ARSIZE,
							output	[1	:	0]								ARBURST,
							output											ARVALID,
							output	[1	:	0]								ARLOCK,
							output	[1	:	0]								ARCACHE,
							output	[2	:	0]								ARPROT,
							input												ARREADY,
							
							/////////AXI READ Data signals
							input		[7	:	0]								RID,
							input		[data_width-1	:	0]				RDATA,
							input		[1	:	0]								RRESP,
							input												RLAST,
							input												RVALID,
							output											RREADY,
							
							////////////Decoder Interface   
																		//////////write control and data from decoder
							input		[3	:	0]								TXN_ID_W_d,
							input		[addr_width-1	:	0]				awaddr_d,
							input		[7	:	0]								awlen_d, 
							input		[2	:	0]								awsize_d,
							input		[1	:	0]								awburst_d,
							input		[1	:	0]								awlock_d,
							input		[1	:	0]								awcache_d,
							input		[2	:	0]								awprot_d,
							
							input		[data_width-1	:	0]				wdata_d,
						   input		[7	:	0]								wstrb_d,
							
							output	[1	:	0]								bresp_d,
							output	[3	:	0]								bid_d,
							output											wr_rsp_en_d,
							
							input												wr_trn_en,
							
																			///////READ control from decoder
							input		[3	:	0]								TXN_ID_R_d,
							input		[addr_width-1	:	0]				araddr_d,
							input		[7	:	0]								arlen_d, 
							input		[2	:	0]								arsize_d,
							input		[1	:	0]								arburst_d,
							input		[1	:	0]								arlock_d,
							input		[1	:	0]								arcache_d,
							input		[2	:	0]								arprot_d,
							
							output	[data_width-1	:	0]				rdata_d,
							output	[1	:	0]								rresp_d,
							output	[7	:	0]								rid_d,
							output											rd_rsp_en_d,
							output											r_last_d,
                     
							
							input												rd_trn_en
							

							);
							


//////////////////////////AXI WRITE CONTROL FSM MODULE ///////////////////////////

					
AXI_MASTER_WRITE__CONTROL  #(.addr_width(32), .data_width(64)) AXI_WRITE_CONTROL
						  (
						   /////////AXI Global signals clock and reset
                     	.AClk(AClk),
								.ARst(ARst),
						
							/////////////AXI Write Address signals
								.AWID(AWID),           
								.AWADDR(AWADDR), 
								.AWLEN(AWLEN),
								.AWSIZE(AWSIZE),
								.AWBURST(AWBURST),
								.AWVALID(AWVALID),
								.AWLOCK(AWLOCK),
								.AWCACHE(AWCACHE),
								.AWPROT(AWPROT),
								.AWREADY(AWREADY),
							
							
							////////AXI Write Data channel signals
								.WID(WID),   
								.WSTRB(WSTRB),
								.WDATA(WDATA),
								.WLAST(WLAST),
								.WVALID(WVALID),
								.WREADY(WREADY),   
							
							/////////AXI Write Response  channel signals
								.BID(BID),
								.BRESP(BRESP),
								.BVALID(BVALID),
								.BREADY(BREADY),
							
		//////////////////////////////Decoder Interface signals////////////////////////////
		              		.awaddr_d(awaddr_d),
								.TXN_ID_W_d(TXN_ID_W_d),
								.awburst_d(awburst_d),
								.awlen_d(awlen_d),
								.awsize_d(awsize_d),
								.awlock_d(awlock_d),
								.awcache_d(awcache_d),
								.awprot_d(awprot_d),
							   
								.wdata_d(wdata_d),			
								.wstrb_d(wstrb_d),
							
								.bresp_d(bresp_d),
								.bid_d(bid_d),
								.wr_rsp_en_d(wr_rsp_en_d),
								.wr_trn_en(wr_trn_en)
							);


/////////////////////AXI READ FSM MODULE////////////////////////////////////


AXI_MASTER_READ_Control	#(.addr_width(32), .data_width(64)) AXI_READ_CONTROL
						 (
						   /////////AXI Global signals clock and reset
								.AClk(AClk),
								.ARst(ARst),
						/////////////////////////////AXI INTERFACE//////////////////////////////////////////////	
						/////////AXI READ CHannel signals
					
								.ARID(ARID),           
								.ARADDR(ARADDR), 
								.ARLEN(ARLEN),
								.ARSIZE(ARSIZE),
								.ARBURST(ARBURST),
								.ARVALID(ARVALID),
								.ARLOCK(ARLOCK),
								.ARCACHE(ARCACHE),
								.ARPROT(ARPROT),
								.ARREADY(ARREADY),
						  
							
							/////////AXI READ Data signals
								.RDATA(RDATA),
								.RRESP(RRESP),
								.RLAST(RLAST),
								.RID(RID),
								.RVALID(RVALID),
								.RREADY(RREADY),
							
							
							
						
							
		//////////////////////////////Decoder Interface signals////////////////////////////
		               	.araddr_d(araddr_d),
								.TXN_ID_R_d(TXN_ID_R_d),
								.arburst_d(arburst_d),
								.arlen_d(arlen_d),
								.arsize_d(arsize_d),
								.arlock_d(arlock_d),
								.arcache_d(arcache_d),
								.arprot_d(arprot_d),
							
								.rdata_d(rdata_d),			
								.rresp_d(rresp_d), 
								.rid_d(rid_d),
								.rd_rsp_en_d(rd_rsp_en_d),
								.r_last_d(r_last_d),
								.rd_trn_en(rd_trn_en)
							
							);
							










endmodule

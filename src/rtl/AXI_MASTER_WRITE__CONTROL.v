`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:31:47 08/09/2022 
// Design Name: 
// Module Name:    AXI_MASTER_WRITE__CONTROL 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module AXI_MASTER_WRITE__CONTROL #(parameter  addr_width=32, 
											  parameter  data_width=64, 			/////data width 8,16,32,64,....1024 bits
											  parameter	 strobe_width =(data_width/8)
											  
						               )
						 (
						   /////////AXI Global signals clock and reset
                     input							AClk,
							input							ARst,
						/////////////////////////////AXI INTERFACE//////////////////////////////////////////////	
							/////////////AXI Write Address signals
							output	[7	:	0]								AWID,           
							output	[addr_width-1	:	0]				AWADDR, 
							output	[7	:	0]								AWLEN,
							output	[2	:	0]								AWSIZE,
							output	[1	:	0]								AWBURST,
							output											AWVALID,
							output	[1	:	0]								AWLOCK,
							output	[1	:	0]								AWCACHE,
							output	[2	:	0]								AWPROT,
							input												AWREADY,
							
							
							////////AXI Write Data channel signals
							output	[7	:	0]								WID,   
							output	[strobe_width-1	:	0]			WSTRB,
							output	[data_width-1		:	0]			WDATA,
							output											WLAST,
							output											WVALID,
							input												WREADY,   
							
							/////////AXI Write Response  channel signals
							input		[7	:	0]								BID,   
							input		[1	:	0]								BRESP,
							input												BVALID,
							output											BREADY,
							
		//////////////////////////////Decoder Interface signals////////////////////////////
																		//////////write address and control information from decoder
		               input		[addr_width-1	:	0]				awaddr_d,
							input		[3	:	0]								TXN_ID_W_d,
							input		[1	:	0]								awburst_d,
							input		[3	:	0]								awlen_d,
							input		[2	:	0]								awsize_d,
							input		[1	:	0]								awlock_d,
							input		[1	:	0]								awcache_d,
							input		[2	:	0]								awprot_d,
							
																		////////////////////write data and strobe from decoder
							input		[data_width-1		:	0]			wdata_d,			
							input		[strobe_width-1	:	0]			wstrb_d,
							
							                                   /////////////response to decoder
							output	[1	:	0]								bresp_d, 
							output	[3	:	0]								bid_d,
							output											wr_rsp_en_d,
							
							input												wr_trn_en
							
							
    );

reg			[addr_width-1	:	0]				aw_addr;        
reg			[7	:	0]								aw_len;  
reg			[7	:	0]								aw_id;  
reg			[2	:	0]								aw_size;
reg			[7	:	0]								burst_size;
reg			[1	:	0]								aw_burst;
reg			[1	:	0]								awlock;   
reg			[1	:	0]								awcache;
reg			[2	:	0]								awprot;
reg													aw_valid;
reg													aw_ready;

reg			[addr_width-1	:	0]				wr_addr;
reg													aw_valid_t;

reg			[data_width-1		:	0]			w_data;
reg			[strobe_width-1	:	0]			w_strb;			
reg			[7	:	0]								w_id;
reg													w_last;
reg													w_valid;
reg													w_valid_t;
reg													w_ready;

reg			[1	:	0]								b_resp;   
reg			[7	:	0]								b_id;
reg													b_valid;
reg													b_ready;
reg													b_ready_t;
reg													wr_rsp_en;

wire			[7	:	0]								BL;

reg			[addr_width-1	:	0]				awaddr_r;     
reg			[7	:	0]								TXN_ID_W_r;
reg			[1	:	0]								awburst_r;
reg			[7	:	0]								awlen_r;
reg			[2	:	0]								awsize_r;
reg			[2	:	0]								awsize_reg;
reg			[1	:	0]								awlock_r;
reg			[1	:	0]								awcache_r;
reg			[2	:	0]								awprot_r;
reg			[strobe_width-1	:	0]			w_strb_r;   
reg			[strobe_width-1	:	0]			w_strb_reg;
reg			[data_width-1	:	0]				w_data_r;
reg			[data_width-1	:	0]				w_data_r1;	
wire			[data_width-1	:	0]				w_data_r2;
reg			[data_width-1	:	0]				w_data_reg;	

reg			[7	:	0]								beat_cnt;
reg			[7	:	0]								beat_cnt_reg;
reg													wr_trn_en_reg;

reg													address_en;
reg													data_en;
reg													beat_cnt_en;



//////////BURST TYPES
localparam	[1	:	0]								Fixed_Burst		=		2'b00;
localparam	[1	:	0]								INCR_Burst		=		2'b01;
localparam	[1	:	0]								Wrap_Burst		=		2'b10;



localparam	[7	:	0]								Max_burst_len	=		8'hff;  			//////256 for AXI 4
																										//////16 for AXI 3
																							  
reg 			[2	: 	0]								pst,nst;

localparam	[2	:	0]								Idle				=		3'b000;
localparam	[2	:	0]								Addr_st			=		3'b001;
localparam	[2	:	0]								Data_st			=		3'b010;
localparam	[2	:	0]								Resp_st			=		3'b011;


//////////////////////////////////////
//////final AXI WRITE CHANNEL OUTPUTS
///
assign		AWID			=			aw_id;						 				
assign		AWADDR		=			aw_addr;		
assign		AWLEN			=			aw_len;
assign		AWSIZE		=			aw_size;		
assign		AWBURST		=			aw_burst;
assign		AWVALID		=			aw_valid;
assign		AWLOCK		=			awlock;
assign		AWCACHE		=			awcache;
assign		AWPROT		=			awprot;
assign		WID			=			w_id;	
assign		WSTRB			=			w_strb;
assign		WDATA			=			w_data;
assign		WLAST			=			w_last;
assign		WVALID		=			w_valid;
assign		BREADY		=			b_ready;
assign      bresp_d		=			b_resp;
assign		bid_d			=			b_id[3:0];
assign		wr_rsp_en_d	=			wr_rsp_en;




//////////////////////////////////////////////////////////////////
/////register the input address and burst controls
//////
always @(posedge AClk)
begin
   if(!ARst)
	  begin
	    awaddr_r				<=		{addr_width{1'bz}};
		 TXN_ID_W_r				<=		8'bz;
		 awburst_r				<=		2'bz;
		 awlen_r					<=		8'bz;
		 awsize_r 				<=		3'bz;
		 awlock_r				<=		2'bz;
		 awcache_r				<=		2'bz;
		 awprot_r				<=		3'bz;
		 w_strb_r				<=		{strobe_width{1'b0}};
//		 w_data_r				<=		{data_width{1'bz}};
		 
	  end
	 else
	  begin
		 awaddr_r				<=		awaddr_d;     
		 TXN_ID_W_r				<=		{4'b0,TXN_ID_W_d};
		 awburst_r				<=		awburst_d;
		 awlen_r					<=		{4'b0,awlen_d};
		 awsize_r				<=		awsize_d;
		 awlock_r				<=		awlock_d;
		 awcache_r				<=		awcache_d;
		 awprot_r				<=		awprot_d; 
       w_strb_r				<=		wstrb_d;   
//		 w_data_r				<=		wdata_d;	

      		 
			  
	  end
end

assign	BL					=		awlen_r	+	8'h01;			////burst length


///////////////////////wdata with strobe muxing 
genvar n;
generate
		 for (n = 0; n < strobe_width; n = n + 1) 
	    begin
		  assign w_data_r2[(8*n)+7	:(8*n)] = (w_strb_r[n]==1'b1) ? (wdata_d[(8*n)+7	:(8*n)]) : (w_data_r1[(8*n)+7	:(8*n)]);
      end
endgenerate

/////////////////////////////////register the wstrobe mux out
always @(posedge AClk)
begin
   if(!ARst)
	  w_data_r1		<=		{data_width{1'bz}};
	 else
	  w_data_r1		<=		w_data_r2;
end

	  

/////////////////////////////checking awsize from decoder and align the strobe with wdata
///INCR_Burst,Wrap_Burst

always @(w_data_r1,w_strb_r,awburst_r)
begin
	if((awburst_r==INCR_Burst) || (awburst_r==Wrap_Burst))
		begin
		
		case(awsize_r)
		
		3'b000		:	begin												///size 8 bit
											awsize_reg			=		3'b000;
											w_data_reg			=		w_data_r1;
											w_strb_reg			=		w_strb_r;
							end
						
		3'b001		:	begin												///size 16 bit
											awsize_reg			=		3'b001;
											w_data_reg			=		w_data_r1;
											w_strb_reg			=		w_strb_r;
							end
						
		3'b010		:	begin												///size 32 bit
											awsize_reg			=		3'b010;
											w_data_reg			=		w_data_r1;
											w_strb_reg			=		w_strb_r;
							end
		3'b011		:	begin												///size 64 bit
											awsize_reg			=		3'b011;
											w_data_reg			=		w_data_r1;
											w_strb_reg			=		w_strb_r;
							end
		3'b100		:	begin												///size 128 bit
											awsize_reg			=		3'b100;
											w_data_reg			=		w_data_r1;
											w_strb_reg			=		w_strb_r;
							end
						
		3'b101		:	begin												///size 256 bit
											awsize_reg			=		3'b101;
											w_data_reg			=		w_data_r1;
											w_strb_reg			=		w_strb_r;
							end
						
		3'b110		:	begin												///size 512 bit
											awsize_reg			=		3'b110;
											w_data_reg			=		w_data_r1;
											w_strb_reg			=		w_strb_r;
							end
		3'b111		:	begin												///size 1024 bit
											awsize_reg			=		3'b111;
											w_data_reg			=		w_data_r1;
											w_strb_reg			=		w_strb_r;
							end
      default		:  begin
											awsize_reg			=		3'b010;
											w_data_reg			=		w_data_r1;
											w_strb_reg			=		w_strb_r;
		               end
		endcase
	 end
				
	end
	
always @(posedge AClk)
begin
   if(!ARst)
	  wr_trn_en_reg		<=			  1'b0;
	  else
	    begin
		   if(wr_trn_en)
			  wr_trn_en_reg		<=			  1'b1;
			  else
			  wr_trn_en_reg		<=			  1'b0;
		 end
end



///////////fsm sequenctial stage  
always @(posedge AClk)
begin
   if(!ARst)
	  pst				<=				Idle;
	  else
	  pst				<=				nst;
end

/////////////////next state logic ///
always @(pst,AWREADY,WREADY,BID,BRESP,BVALID,aw_valid,w_valid,w_valid_t,b_ready,wr_trn_en_reg)
begin
   case(pst)
	3'b000		:	begin														///idle state 
	                
	                if(wr_trn_en_reg==1'b1)
						   nst			=		Addr_st;
							else 
							nst			=		Idle;
	               end
						
	3'b001		:	begin										
																/////write Address state ///check the AWREADY  
						 if(AWREADY)
						     nst			=		Data_st;
							  else
							  nst			=		Addr_st;	
						 							  
	
						    
	               end	
	

	3'b010		:	begin							///write DATA state//////send first wdata or Burst data and asser wvalid
	                   
							 if(beat_cnt>1)
									nst			=		Data_st;
								else  
									nst			=		Resp_st;
	               
						
						
						end	


	3'b011		:	begin									///write Response state//////check the bvalid and response
	                    if(b_ready && BVALID)  
							    begin
							     if(wr_trn_en_reg==1'b1)
								     nst			=		Addr_st;
									  else
									  nst			=		Idle;
								 end
								else
								   nst			=		Resp_st;
									
					    
	               end
						
	default		:	begin
								nst			=		Idle;
	               end	
 endcase						
end

///////////////////////////////////////FSM OUTPUT LOGIC
always @(posedge AClk)
begin
if(!ARst)
begin

		 aw_addr				<=		{addr_width{1'bz}};
		 aw_id				<=		8'bz;
		 aw_burst			<=		2'bz;
		 aw_len				<=		8'bz;
		 aw_size				<=		3'bz;
		 awlock				<=		2'bz;
		 aw_valid			<=		1'b0;
		 awcache				<=		2'bz;
		 awprot				<=		3'bz;
		 w_strb				<=		{strobe_width{1'bz}};
		 w_data				<=		{data_width{1'bz}};
		 w_id					<=		8'bz;
		 b_id					<=		8'bz;
		w_valid_t			<=		1'b0;
		 w_valid				<=		1'b0;
		 b_ready				<=		1'b0;
		 
		 wr_rsp_en			<=		1'b0;
		 
end
else
 begin
   case(pst)
	3'b000		:	begin														
	                aw_addr				<=		{addr_width{1'bz}};
						 aw_id				<=		8'bz;
						 aw_burst			<=		2'bz;
						 aw_len				<=		8'bz;
						 aw_size				<=		3'bz;
						 awlock				<=		2'bz;
						 aw_valid			<=		1'b0;
						 awcache				<=		2'bz;
						 awprot				<=		3'bz;
						 w_data				<=		{data_width{1'bz}};
						 w_strb				<=		{strobe_width{1'bz}};
						 w_id					<=		8'bz;
                   w_valid_t			<=		1'b0;
						 w_valid				<=		1'b0;
						 b_ready				<=		1'b0;
						 wr_rsp_en			<=		1'b0;
						 
//						 beat_cnt			<=		8'b0;
						 
	               end
						
	3'b001		:	begin							
	
						 aw_addr				<=		awaddr_r;
						 aw_id				<=		TXN_ID_W_r;
						 aw_burst			<=		awburst_r;
						 aw_len				<=		awlen_r;
						 aw_size				<=		awsize_reg;
						 awlock				<=		awlock_r;
						 aw_valid			<=		1'b1;
						 awcache				<=		awcache_r;
						 awprot				<=		awprot_r;
						 w_data				<=		{data_width{1'bz}};
						 w_id					<=		8'bz;
						 w_valid_t			<=		1'b0;
						 w_valid				<=		1'b0;
						 b_ready				<=		1'b0;
						    
	               end	

	               
	3'b010		:	begin						/////send first wdata in burst or single data and assert wvalid
	                
						 aw_addr				<=		{addr_width{1'bz}};
						 aw_id				<=		8'bz;
						 aw_burst			<=		2'bz;
						 aw_len				<=		8'bz;
						 aw_size				<=		3'bz;
						 awlock				<=		2'bz;
						 aw_valid			<=		1'b0;
						 awcache				<=		2'bz;
						 awprot				<=		3'bz;
						 w_valid_t			<=		1'b1;
						 w_data				<=		w_data_reg; 
						 
						 w_id					<=		TXN_ID_W_r;
						 w_strb				<=		w_strb_reg;
						 b_ready				<=		1'b0;
						 wr_rsp_en			<=		1'b0;
						 
							if(beat_cnt>8'h01)
						   w_valid				<=		1'b1;
							else
							w_valid				<=		1'b0;
							
						 

						
						
						
						end	
					
	3'b011		:	begin																///write response output
	
	                w_data				<=		{data_width{1'bz}};
						 w_id					<=		8'bz;

						 w_valid				<=		1'b0;
						 b_ready				<=		1'b1;

	
	                  if(BVALID && b_ready)
							 begin
							b_resp			<=		BRESP;
							b_id				<=		BID;
							wr_rsp_en		<=		1'b1;
							end 
							else
							  begin
							  b_resp			<=		b_resp;
	                    b_id			<=		b_id;
							  wr_rsp_en		<=		1'b0;
							  end
						end
						
	default		:	begin
								aw_addr				<=		{addr_width{1'bz}};
								aw_id					<=		8'bz;
								aw_burst				<=		2'bz;
								aw_len				<=		8'bz;
								aw_size				<=		3'bz;
								awlock				<=		2'bz;
								aw_valid				<=		1'b0;
								awcache				<=		2'bz;
								awprot				<=		3'bz;
								w_data				<=		{data_width{1'bz}};
								w_strb				<=		4'bz;
								w_id					<=		8'bz;
								w_valid_t			<=		1'b0;
								w_valid				<=		1'b0;
								b_ready				<=		1'b0;
								wr_rsp_en			<=		1'b0;
	               end	
 endcase						
end
end

///////////////////////////////////wlast generation
always @(pst,beat_cnt)
begin
if((pst==3'b010) && (beat_cnt==1))
  w_last		<=		1'b1;
  else
  w_last		<=		1'b0;
end
  
////////Burst Beat counter logic for handling INCR or FIxed with respective Wready signal from AXI slave
always @(posedge AClk)
begin
if(!ARst)
  beat_cnt			<=		8'h0;
 else
   begin
	if(pst==Addr_st)
	  beat_cnt			<=		BL;
	  else
	  if(pst==Data_st)
	   begin
	    if(WREADY && (beat_cnt>0))
		   beat_cnt		<=		beat_cnt - 8'h01;
		else
		   beat_cnt		<=		beat_cnt;
		end 
		 else 
		   beat_cnt		<=		0;
	end
end



			


endmodule

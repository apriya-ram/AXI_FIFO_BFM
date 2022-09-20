`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company				:		 
// Engineer				: 	
// 
// Create Date			:    13:57:02 08/09/2022 
// Design Name			:	  AXI Master Interface Design	 
// Module Name			:    AXI_MASTER_READ_Control 
// Project Name		: 
// Target Devices		: 
// Tool versions		: 
// Description			: 
//
// Dependencies		: 
//
// Revision				: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module AXI_MASTER_READ_Control	#(parameter  addr_width=32, 
											  parameter  data_width=64
						               )
						 (
						   /////////AXI Global signals clock and reset
                     input							AClk,
							input							ARst,
						/////////////////////////////AXI INTERFACE//////////////////////////////////////////////	
						/////////AXI READ CHannel signals
						   output	[7	:	0]								ARID,
							output	[addr_width-1	:	0]				ARADDR,
							output	[7	:	0]								ARLEN,
							output	[2	:	0]								ARSIZE,
							output	[1	:	0]								ARBURST,
							output											ARVALID,
							input												ARREADY,
							output	[1	:	0]								ARLOCK,
							output	[1	:	0]								ARCACHE,
							output	[2	:	0]								ARPROT,
							
							/////////AXI READ Data signals
							input		[data_width-1	:	0]				RDATA,
							input		[1	:	0]								RRESP,
							input												RLAST,
							input		[7	:	0]								RID,
							input												RVALID,
							output											RREADY,
							
							
							
						
							
		//////////////////////////////Decoder Interface signals////////////////////////////
		
																				//////Read Address and Control information from Decoder
		               input		[addr_width-1	:	0]				araddr_d,
							input		[3	:	0]								TXN_ID_R_d,
							input		[1	:	0]								arburst_d,
							input		[3	:	0]								arlen_d,
							input		[2	:	0]								arsize_d,
							input		[1	:	0]								arlock_d,
							input		[1	:	0]								arcache_d,
							input		[2	:	0]								arprot_d,
							
																				/////Read DATA and Response to Decoder
							output	[data_width-1	:	0]				rdata_d,						
							output	[1	:	0]								rresp_d, 
							output	[3	:	0]								rid_d,
							output											rd_rsp_en_d,
							output	reg									r_last_d,
							
							input												rd_trn_en
							
							);
							
							

reg			[addr_width-1	:	0]				ar_addr;        
reg			[7	:	0]								ar_len;  
reg			[7	:	0]								ar_id;  
reg			[2	:	0]								ar_size;
reg			[1	:	0]								ar_burst;
reg			[1	:	0]								arlock;   
reg			[1	:	0]								arcache;
reg			[2	:	0]								arprot;
reg													ar_valid;
reg													ar_ready;

reg			[addr_width-1	:	0]				rd_addr;
reg													ar_valid_t;

reg			[data_width-1	:	0]				r_data;			
reg			[3	:	0]								r_id;
reg													r_last;
reg													r_valid;
reg													r_ready;

reg			[1	:	0]								r_resp;   
reg													r_ready_t;
reg													rd_rsp_en;

wire			[7	:	0]								BL;

reg			[addr_width-1	:	0]				araddr_r;     
reg			[7	:	0]								TXN_ID_R_r;
reg			[1	:	0]								arburst_r;
reg			[7	:	0]								arlen_r;
reg			[2	:	0]								arsize_r;
reg			[1	:	0]								arlock_r;
reg			[1	:	0]								arcache_r;
reg			[2	:	0]								arprot_r;   
reg			[data_width-1	:	0]				r_data_r;	
reg			[7	:	0]								r_id_r;
reg			[1	:	0]								r_resp_r;
reg													rd_rsp_en_r;

reg			[7	:	0]								beat_cnt;
reg			[7	:	0]								beat_cnt_reg;
reg													rd_trn_en_reg;

reg													address_en;
reg													data_en;
reg													beat_cnt_en;



//////////BURST TYPES
localparam	[1	:	0]								Fixed_Burst		=		2'b00;
localparam	[1	:	0]								INCR_Burst		=		2'b01;
localparam	[1	:	0]								Wrap_Burst		=		2'b10;


localparam	[7	:	0]								Max_burst_len	=		8'hff;  //////256 for AXI 4
																							  //////16 for AXI 3
																							  
reg 			[2	: 	0]								pst,nst;

localparam	[1	:	0]								Idle				=		2'b00;
localparam	[1	:	0]								Addr_st			=		2'b01;
localparam	[1	:	0]								Data_st			=		2'b10;

//////////////////////////////////////
//////final AXI R CHANNEL OUTPUTS
///
assign		ARID			=			ar_id;						 				
assign		ARADDR		=			ar_addr;		
assign		ARLEN			=			ar_len;
assign		ARSIZE		=			ar_size;		
assign		ARBURST		=			ar_burst;
assign		ARVALID		=			ar_valid;
assign		ARLOCK		=			arlock;
assign		ARCACHE		=			arcache;
assign		ARPROT		=			arprot;
assign		RREADY		=			r_ready;

////////////////////////////////////////////////READ DATA and Response to Decoder
assign      rresp_d		=			r_resp_r;
assign		rid_d			=			r_id_r[3:0];
assign		rd_rsp_en_d	=			rd_rsp_en_r;
assign		rdata_d		=			r_data_r;



//////////////////////////////////////////////////////////////////
/////register the input address and burst controls
//////
always @(posedge AClk)
begin
   if(!ARst)
	  begin
	    araddr_r				<=		{addr_width{1'bz}};
		 TXN_ID_R_r				<=		8'bz;
		 arburst_r				<=		2'bz;
		 arlen_r					<=		8'bz;
		 arsize_r				<=		3'bz;
		 arlock_r				<=		2'bz;
		 arcache_r				<=		2'bz;
		 arprot_r				<=		3'bz;
		 
		 r_last_d				<=		1'b0;

		 
	  end
	 else
	  begin
		 araddr_r				<=		araddr_d;     
		 TXN_ID_R_r				<=		{4'b0,TXN_ID_R_d};
		 arburst_r				<=		arburst_d;
		 arlen_r					<=		{4'b0,arlen_d};
		 arsize_r				<=		arsize_d;
		 arlock_r				<=		arlock_d;
		 arcache_r				<=		arcache_d;
		 arprot_r				<=		arprot_d;
														//////////RLAST registering
		 r_last_d				<=		RLAST;

			  
	  end
end

assign	BL					=		arlen_r	+	8'h01;			////burst length

always @(posedge AClk)
begin
   if(!ARst)
	  rd_trn_en_reg		<=			  1'b0;
	  else
	    begin
		   if(rd_trn_en)
			  rd_trn_en_reg		<=			  1'b1;
			  else
			  rd_trn_en_reg		<=			  1'b0;
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
always @(pst,ARREADY,RID,RRESP,RVALID,RLAST,ar_valid,r_ready,rd_trn_en_reg,beat_cnt)
begin
   case(pst)
	2'b00			:	begin														///idle   
	                
	                if(rd_trn_en_reg==1'b1)
						   nst			=		Addr_st;
							else 
							nst			=		Idle;
	               end
						
	2'b01			:	begin										
																/////read Address state ///check the ARREADY  
						 if(ar_valid && ARREADY)
						     nst			=		Data_st;
							  else
							  nst			=		Addr_st;	
						 							  
	
						    
	               end	
	

	2'b10			:	begin							///read DATA state//////receive single rdata or Burst rdata 
	                   
							 if((beat_cnt>1) && RVALID && (!RLAST))
									nst			=		Data_st; 
								else  if(RLAST )
									nst			=		Addr_st;
								
	               
						
						
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

		 ar_addr				<=		{addr_width{1'bz}};
		 ar_id				<=		8'bz;
		 ar_burst			<=		2'bz;
		 ar_len				<=		8'bz;
		 ar_size				<=		3'bz;
		 arlock				<=		2'bz;
		 ar_valid			<=		1'b0;
		 arcache				<=		2'bz;
		 arprot				<=		3'bz;
		 r_ready				<=		1'b0;
		 
		 r_data_r			<=		{data_width{1'bz}};
		 r_id_r				<=		8'bz;
		 r_resp_r			<=		2'bz;
		 rd_rsp_en_r		<=		1'b0;
		 
end
else
 begin
   case(pst)
	2'b00			:	begin														
	                ar_addr				<=		{addr_width{1'bz}};
						 ar_id				<=		8'bz;
						 ar_burst			<=		2'bz;
						 ar_len				<=		8'bz;
						 ar_size				<=		3'bz;
						 arlock				<=		2'bz;
						 ar_valid			<=		1'b0;
						 arcache				<=		2'bz;
						 arprot				<=		3'bz;
						 r_ready				<=		1'b0;
						 
						 r_data_r			<=		{data_width{1'bz}};
						 r_id_r				<=		8'bz;
						 r_resp_r			<=		2'bz;
						 rd_rsp_en_r		<=		1'b0;
						 
						 
	               end
						
	2'b01			:	begin							
	
						 ar_addr				<=		araddr_r;
						 ar_id				<=		{4'b0,TXN_ID_R_r};
						 ar_burst			<=		arburst_r;
						 ar_len				<=		arlen_r;
						 ar_size				<=		arsize_r;
						 arlock				<=		arlock_r;
						 ar_valid			<=		1'b1;
						 arcache				<=		arcache_r;
						 arprot				<=		arprot_r;
						 r_ready				<=		1'b0;
						 r_data_r			<=		{data_width{1'bz}};
						 r_id_r				<=		8'bz;
						 r_resp_r			<=		2'bz;
						 
						    
	               end	

	               
	2'b10			:	begin						/////receive single rdata or burst rdata 
	                
						 ar_addr				<=		{addr_width{1'bz}};
						 ar_id				<=		8'bz;
						 ar_burst			<=		2'bz;
						 ar_len				<=		8'bz;
						 ar_size				<=		3'bz;
						 arlock				<=		2'bz;
						 ar_valid			<=		1'b0;
						 arcache				<=		2'bz;
						 arprot				<=		3'bz;
						 r_ready				<=		1'b1;
						 
						 
				   if(RVALID && (beat_cnt>0))
						begin
  						 r_data_r			<=		RDATA;
						 r_id_r				<=		RID;
						 r_resp_r			<=		RRESP;
						 rd_rsp_en_r		<=		1'b1;
						end
					 else
					   begin
					    r_data_r			<=		r_data_r;
						 r_id_r				<=		r_id_r;
						 r_resp_r			<=		r_resp_r;
						 rd_rsp_en_r		<=		1'b0;
						end 
										
						
						
						end	
					
	
						
	default		:	begin
								ar_addr				<=		{addr_width{1'bz}};
								ar_id					<=		8'bz;
								ar_burst				<=		2'bz;
								ar_len				<=		8'bz;
								ar_size				<=		3'bz;
								arlock				<=		2'bz;
								ar_valid				<=		1'b0;
								arcache				<=		2'bz;
								arprot				<=		3'bz;
								r_ready				<=		1'b0;
		 
								r_data_r				<=		{data_width{1'bz}};
								r_id_r				<=		8'bz;
								r_resp_r				<=		2'bz;  
								rd_rsp_en_r			<=		1'b0;
	               end	
 endcase						
end
end


  
////////Burst Beat counter logic for handling INCR or FIxed with respective RVALID and RRESP signal from AXI slave
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
	    if(( (!RLAST)&& RVALID) && (beat_cnt>0))
		   beat_cnt		<=		beat_cnt - 8'h01;
		else
		   beat_cnt		<=		beat_cnt;
		end 
		 else 
		   beat_cnt		<=		0;
	end
end


endmodule

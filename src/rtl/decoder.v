module my_decoder #  (
					parameter  data_wid = 64,
	                parameter  adr_wid  = 32,
					parameter  id_wid   = 4,
					parameter  len_wid  = 4,
					parameter  siz_wid  = 3,
					parameter  bst_wid  = 2,
					parameter  loc_wid  = 2,
					parameter  cach_wid = 2,
					parameter  prot_wid = 3,
					parameter  strb_wid = 4
				  )
                 (
                   input                       clk,
                   input                       rst_n,			   
				   
                   //FIFO Interface signals
                   input                       fifo_empty,
				   input [127:0]               fifo_rdata,
				   output reg  	               read_enable,
				   
                   input                       fifo_full,				   
				   output                      write_enable,
				   output reg [127:0]          fifo_wdata,
				   output                      write_data,
				   
				   //address phase packet decoded signals
				   output reg                  wr_trn_en,
		           output reg                  rd_trn_en,
				   
				   output reg [adr_wid-1:0]    awaddr,
                   output reg [id_wid-1:0]     txn_id_w,
                   output reg [bst_wid-1:0]    awburst,
                   output reg [len_wid-1:0]    awlen,

                   output reg [siz_wid-1:0]    awsize,
                   output reg [loc_wid-1:0]    awlock,
                   output reg [cach_wid-1:0]   awcache,
                   output reg [prot_wid-1:0]   awprot,
				   
				   output reg [adr_wid-1:0]    araddr,
                   output reg [id_wid-1:0]     txn_id_r,
                   output reg [bst_wid-1:0]    arburst,
		           output reg [len_wid-1:0]    arlen,
		           output reg [siz_wid-1:0]    arsize,
                   
		           output reg [loc_wid-11:0]   arlock,
                   output reg [cach_wid-1:0]   arcache,
                   output reg [prot_wid-1:0]   arprot,
				   
				   //data phase packet decoded signals
				   output reg [data_wid-1:0]   wdata,
                   output reg [strb_wid-1:0]   wstrb,
				   
				   //read  data and response signals from AXI4 Master
				   input [id_wid-1:0]          rid,
                   input [data_wid-1:0]        rdata,
                   input [1:0]                 rresp,
				   input                       rlast,
				   input                       rd_rsp_en,
				   
				   //write response signals from AXI4 master
				   input [3:0]                 bresp,
                   input [id_wid-1:0]          bid,
				   input                       wr_rsp_en
				   
		   );
		   
//parameter declaration		   
localparam IDLE            = 3'b000; 
localparam FIFO_RD   	   = 3'b001; 
localparam WR_PKT_DEC      = 3'b010;
localparam RD_PKT_DEC      = 3'b011; 		   
		   
// Internal signals
// FIFO-decoder interface
reg[127:0]          fifo_rdata_stored[9:0];
reg[3:0]            store_addr;

reg 				fifo_empty_d1;
wire                sop_detected;
reg                 eop_detected;

reg[2:0]            present_state;
reg[2:0]            next_state;

reg                 decode_wr_pkt;
reg                 decode_rd_pkt; 
integer             i;


//decoder-AXI4 master interface		   
		   
		   
// Read the  address/data phase packet data from the write fifo	
// There are two address phase packets. 1)write address phase packets 2)read address phase packets
// There is one data phase packet : write data phase packet
// Register fifo empty
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		fifo_empty_d1 <= 1'b1;		
	end else begin
		fifo_empty_d1 <= fifo_empty;		
	end
end

//detect sop	
assign sop_detected = (fifo_rdata[127:120] == 8'hAA);

//detect eop by iterating over all the 128 bit words in the internal memory
always @(*)begin	
		for(i=0; i<16; i=i+1) begin:loop			  
			if(fifo_rdata[i*8+:8]== 8'h53) begin
				eop_detected = 1'b1;
				disable loop;
			end
		end	
	
end

//control state machine 
always @ (posedge clk or negedge rst_n)  begin 
    if (rst_n == 1'b0) begin
      present_state <= IDLE;
    end else begin
      present_state <= next_state;
    end
end

always @(*) begin
    read_enable = 1'b0;	
	wr_trn_en = 1'b0;
	rd_trn_en = 1'b0;
	case(present_state)
		IDLE: begin
				decode_rd_pkt= 1'b0;
				decode_wr_pkt = 1'b0;
				wr_trn_en = 1'b0;
				rd_trn_en = 1'b0;
				if( fifo_empty_d1) begin
					next_state = IDLE;
					read_enable = 1'b0;
				end else begin
					next_state = FIFO_RD;
					read_enable = 1'b1;
				end	
			  end
		FIFO_RD:begin
					if(sop_detected == 1'b1 && fifo_rdata[63:56]== 8'h00 && fifo_rdata[55:48]== 8'h53) begin
						next_state = RD_PKT_DEC;
						rd_trn_en = 1'b1;
					end else begin
						next_state = WR_PKT_DEC;
						wr_trn_en = 1'b1;
					end
					
				end
		WR_PKT_DEC: begin		            
		              decode_wr_pkt = 1'b1;
					  if(eop_detected == 1'b1 && ~fifo_empty_d1) begin
					    next_state = FIFO_RD;
					  end else if(eop_detected == 1'b1 && fifo_empty_d1) begin
                        next_state = IDLE;   					  
					  end else begin
					    next_state = WR_PKT_DEC; 
					  end
					end
		RD_PKT_DEC: begin
					  decode_rd_pkt = 1'b1;
					  if(eop_detected == 1'b1 && ~fifo_empty_d1) begin
					    next_state = FIFO_RD;
					  end else if(eop_detected == 1'b1 && fifo_empty_d1) begin
                        next_state = IDLE;	
					  end else begin
					    next_state = RD_PKT_DEC; 
					  end
					end
		default: next_state = IDLE;	
	endcase   
end  

//decode the write address/data phase packets and send the decoded fields at the output	   
always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 1'b0) begin
		txn_id_w     <= {id_wid{1'b0}};
        awaddr       <= {adr_wid{1'b0}};
        awlen        <= {len_wid{1'b0}};
		awsize       <= {siz_wid{1'b0}};
        awburst      <= {bst_wid{1'b0}};
	    awlock       <= {loc_wid{1'b0}};
	    awcache      <= {cach_wid{1'b0}};
	    awprot       <= {prot_wid{1'b0}};
	    wstrb        <= {strb_wid{1'b0}};
	    wdata        <= {data_wid{1'b0}};	
	end else begin
		if(decode_wr_pkt) begin
			txn_id_w     <=  fifo_rdata[119:116];
			awaddr       <=  fifo_rdata[115:84];
			awlen        <=  fifo_rdata[83:80];
			awsize       <=  fifo_rdata[79:77];
			awburst      <=  fifo_rdata[76:75];
			awlock       <=  fifo_rdata[74:73];
			awcache      <=  fifo_rdata[72:71];
			awprot       <=  fifo_rdata[70:68];
			wstrb        <=  fifo_rdata[67:64];
			wdata        <=  {fifo_rdata[63:8]};
		end	
	end
end	

//decode the read address phase packets and send the decoded fields at the output
always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 1'b0)begin
		txn_id_r     <= {id_wid{1'b0}};
        araddr       <= {adr_wid{1'b0}};
        arlen        <= {len_wid{1'b0}};
		arsize       <= {siz_wid{1'b0}};
        arburst      <= {bst_wid{1'b0}};
	    arlock       <= {loc_wid{1'b0}};
	    arcache      <= {cach_wid{1'b0}};
	    arprot       <= {prot_wid{1'b0}};
	end else begin
		if(decode_rd_pkt) begin
			txn_id_r     <=  fifo_rdata[119:116];
			araddr       <=  fifo_rdata[115:84];
			arlen        <=  fifo_rdata[83:80];
			arsize       <=  fifo_rdata[79:77];
			arburst      <=  fifo_rdata[76:75];
			arlock       <=  fifo_rdata[74:73];
			arcache      <=  fifo_rdata[72:71];
			arprot       <=  fifo_rdata[70:68];		
		end
	end
end	

endmodule


















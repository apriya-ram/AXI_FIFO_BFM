//its considered that sop bits will be at starting of the packet
//the decoded burst length is consaisdered in bytes i.e byte alligned
//to write into write fifo 2 more signals are required to judge the valid resp

module decoder #  

                 (
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
				   
		   input [3:0]                 bresp,
                   input [id_wid-1:0]          bid,
                   
                   input                       fifo_empty,
                   input                       fifo_full,
                   input [127:0]               fifo_rdata,
				   
		   input [id_wid-1:0]          rid,
                   input [data_wid-1:0]        rdata,
                   input [1:0]                 rresp,

		   input                       wr_rsp_en,
		   input                       rd_rsp_en,
            	   output reg  	               read_enable,

		   output                      write_enable,
		   output                      write_data,				
                   output reg [127:0]          fifo_wdata,
                
                   output reg [adr_wid-1:0]    awaddr,
                   output reg [id_wid-1:0]     txn_id_w,
                   output reg [bst_wid-1:0]    awburst,
                   output reg [len_wid-1:0]    awlen,

                   output reg [siz_wid-1:0]    awsize,
                   output reg [loc_wid-1:0]    awlock,
                   output reg [cach_wid-1:0]   awcache,
                   output reg [prot_wid-1:0]   awprot,
                   output reg [data_wid-1:0]   wdata,
                   output reg [strb_wid-1:0]   wstrb,
                                     
                   output reg [adr_wid-1:0]    araddr,
                   output reg [id_wid-1:0]     txn_id_r,
                   output reg [bst_wid-1:0]    arburst,
		   output reg [len_wid-1:0]    arlen,
		   output reg [siz_wid-1:0]    arsize,
                   
		   output reg [loc_wid-11:0]   arlock,
                   output reg [cach_wid-1:0]   arcache,
                   output reg [prot_wid-1:0]   arprot,
		   output reg                  wr_trn_en,
		   output reg                  rd_trn_en

                                   
		   );

                   localparam IDLE      = 3'b000; 
                   localparam HDR_DEC   = 3'b001;
                   localparam PROC_DATA = 3'b010;
                   localparam WAIT_DATA = 3'b011;

                   reg [2:0]                  state;
                   reg [2:0]                  nxt_state;
                   reg                        sop_flag;
                   reg                        eop_flag;
                   reg [3:0]                  wrq_cnt;
                   reg [3:0]                  nxt_wrq_cnt;
                   reg [11:0]                 max_payload;
                   reg [11:0]                 mpl_192;
                   reg [11:0]                 mpl_cnt;

                   reg [11:0]                 mpl_with_eop;
                   reg [11:0]                 mpl_with_eop_inst;
                   reg [3:0]                  max_wrq_cnt;
                   reg [1:0]                  size;
                   reg [3:0]                  len;
                   reg [3:0]                  id;
                   reg [31:0]                 addr;
                   reg [1:0]                  burst;
                   reg [1:0]                  lock;
                   reg [1:0]                  cache;
                   reg [2:0]                  prot;
                   reg [3:0]                  strobe;
                   reg [6:0]                  eop_reg_1;//define the size
                   reg [7:0]                  eop_reg_2;//define the size 
                   reg [7:0]                  eop_reg;
                   reg [1:0]                  count; //define the size 
                   //reg        wr_trn_en;
                   //reg        rd_trn_en;
                   reg                        err_flag;
                   reg                        vld_rd_req;
                   reg [15:0]                 rd_req_data;
 
  always @ (posedge clk or negedge rst_n)
  begin//{ 
    if (rst_n == 1'b0)
    begin//{
      state <= IDLE;
    end//}
    else
    begin//{
      state <= nxt_state;
    end//}
  end//}


  always @ (*)
  begin//{
    //FSM State transition
    case (state)
      IDLE :
        begin//{
          if (fifo_empty)
          begin//{
            nxt_state = IDLE;
          end//}
          else
          begin//{
            nxt_state = HDR_DEC;
          end//}
        end//}
      HDR_DEC :
        begin//{
          if (sop_flag & vld_rd_req & ~fifo_empty)
          begin//{
            nxt_state = HDR_DEC;
          end//}
          else if (sop_flag & vld_rd_req & fifo_empty)
          begin//{
            nxt_state = IDLE;
          end//}  
          if ((sop_flag) & (max_payload > 'd56) & (~fifo_empty))
          begin//{
            nxt_state = PROC_DATA;
          end//}
          else if (sop_flag & (max_payload <= 'd56) & fifo_empty)
          begin//{
            nxt_state = IDLE;
          end//}
	  else if ((~sop_flag) & (max_payload <= 'd56) & (fifo_empty))
	  begin//{
	    nxt_state = IDLE;
          end//}
          else if ((~sop_flag) & (max_payload > 'd56) & (fifo_empty))
          begin//{
            nxt_state = IDLE;
          end//}
          else if (sop_flag & (max_payload > 'd56) & fifo_empty)
          begin//{
            nxt_state = WAIT_DATA;
          end//}
	  else
          begin//{
            nxt_state = HDR_DEC;
          end//}	
        end//}
      PROC_DATA :
        begin//{
          if((~(mpl_with_eop_inst > 64)) & (count == 1'b0) & (~fifo_empty))
          begin//{
            nxt_state = HDR_DEC;
          end//}
          else if((~(mpl_with_eop_inst > 64)) & (count == 1'b0) & (fifo_empty))
          begin//{
            nxt_state = IDLE;
          end//}
          else if((~(mpl_with_eop_inst > 64)) & (count == 1'b1) & (~fifo_empty))
          begin//{
            nxt_state = HDR_DEC;
          end//}
          else if((~(mpl_with_eop_inst > 64)) & (count == 1'b1) & (fifo_empty))
          begin//{
            nxt_state = IDLE;
          end//}
          else if ((mpl_with_eop_inst > 64) & (count == 1'b0) & (fifo_empty))
          begin//{
            nxt_state = WAIT_DATA;
          end//}
          else if ((mpl_with_eop_inst > 64) & (count == 1'b0) & (fifo_empty))
          begin//{
            nxt_state = WAIT_DATA;
          end//}
          else if ((mpl_with_eop_inst > 64) & (count == 1'b1) & (fifo_empty))
          begin//{
            nxt_state = WAIT_DATA;
          end//}
          else
          begin//{
            nxt_state = PROC_DATA;
          end//}
        end//}

	WAIT_DATA:
	begin//{
	 if(~ fifo_empty)
         begin//{
	   nxt_state <= PROC_DATA;
	 end//}
	 else
	 begin//{
           nxt_state <= WAIT_DATA;
	 end//}
	end//}
	  
        default :
        begin//{
          nxt_state = IDLE;
        end//}   
    endcase
  end//}

  always @ (*)
  begin//{
   if ( sop_flag == (fifo_rdata[127:120] == 8'hAA))
   begin//{
    id           = fifo_rdata[116 +: 4];
    addr         = fifo_rdata[84  +: 32];
    len          = fifo_rdata[80  +: 4];
    size         = fifo_rdata[77  +: 3];
    burst        = fifo_rdata[75  +: 2];
    lock         = fifo_rdata[73  +: 2];
    cache        = fifo_rdata[71  +: 2];
    prot         = fifo_rdata[68  +: 3];
    strobe       = fifo_rdata[64  +: 4];
    rd_req_data  = fifo_rdata[48 +: 16];
   
    vld_rd_req   = (rd_req_data == 16'h0000_0000_0101_0011);
    max_payload  = ((2 ** size) * (len));
    mpl_cnt      = max_payload - ('d64 + 'd128);
    mpl_with_eop = max_payload + 'd8;
    if (mpl_with_eop <= 'd64)
    begin//{
      max_wrq_cnt  = 'd0;
    end//}
    else  //if ( mpl_with_eop > 'd56)
    begin//{
      max_wrq_cnt = ((mpl_with_eop/'d128 ) + (|mpl_with_eop[6:0]));
    end//}  
  end//}
  end//}


  always @ (*)
  begin//{
    case(state)
      IDLE:
        begin//{
         
          read_enable  = (~fifo_empty);
          sop_flag     = 1'b0;
          eop_flag     = 1'b0;
	  count        = 1'b0;
	  err_flag     = 1'b0;
          txn_id_w     = {id_wid{'b0}};
          awaddr       = {adr_wid{'b0}};
          awlen        = {len_wid{'b0}};
          awburst      = {bst_wid{'b0}};
	  awlock       = {loc_wid{'b0}};
	  awcache      = {cach_wid{'b0}};
	  awprot       = {prot_wid{1'b0}};
	  wstrb        = {strb_wid{1'b0}};
	  wdata        = {data_wid{1'b0}};
	  wr_trn_en    = 1'b0;
	  rd_trn_en    = 1'b0;
        end//}
	
      HDR_DEC:
        begin//{
	  wr_trn_en    = 1'b0;
	  rd_trn_en    = 1'b0;
          if (sop_flag & vld_rd_req)
          begin//{
            rd_trn_en  = 1'b1;
            txn_id_r   = id;
	    araddr     = addr;
	    arlen      = len;
	    arsize     = size;
	    arburst    = burst;
	    arlock     = lock;
	    arcache    = cache;
	    arprot     = prot;
	  end//}  
	  else if (sop_flag &  (max_payload <= 'd56))
          begin//{
            txn_id_w   = id;
	    awaddr     = addr;
	    awlen      = len;
	    awsize     = size;
	    awburst    = burst;
	    awlock     = lock;
	    awcache    = cache;
	    awprot     = prot;
	    wstrb      = strobe;
            //wdata      = fifo_rdata[8  +: max_payload];
	    wr_trn_en  = 1'b1;
	    wdata      = {fifo_rdata [63:8],8'd0};
	    eop_flag   = (fifo_rdata[7:0] == 'd53);
              if ( eop_flag != (eop_reg == 'h53))
	      begin//{
	        err_flag = 1'b1;
                wr_trn_en  = 1'b0;
	      end//}
	      else
	      begin//{
	        err_flag = 1'b0;
                wr_trn_en  = 1'b0;


	      end//}

	  end//}
	  else if (sop_flag & ( (max_payload > 'd56) && (max_payload <= 'd64)))//('d64 >= max_payload > 'd56))
          begin//{
            read_enable  = ~fifo_empty;
            txn_id_w   = id;
	    awaddr     = addr;
	    awlen      = len;
	    awsize     = size;
	    awburst    = burst;
	    awlock     = lock;
	    awcache    = cache;
	    awprot     = prot;
	    wstrb      = strobe;
            wr_trn_en  = 1'b1;
	    wdata      = fifo_rdata[63 : 0];

	    if (max_payload == 'd57)
	    begin//{
              eop_reg_1    = fifo_rdata[6:0];      
            end//}
            else if (max_payload == 'd58)
	    begin//{
              eop_reg_1    = fifo_rdata[5:0];      
            end//}
            else if (max_payload == 'd59)
	    begin//{
              eop_reg_1    = fifo_rdata[4:0];      
            end//}
            else if (max_payload == 'd60)
	    begin//{
              eop_reg_1    = fifo_rdata[3:0];      
            end//}
            else if (max_payload == 'd61)
	    begin//{
              eop_reg_1    = fifo_rdata[3:0];      
            end//}
            else if (max_payload == 'd62)
	    begin//{
              eop_reg_1    = fifo_rdata[2:0];      
            end//}
            else if (max_payload == 'd63)
	    begin//{
              eop_reg_1    = fifo_rdata[1:0];      
            end//}
	    else 
	    begin//{
              eop_reg_1    = {8{1'b0}};
            end//}
	   end//}
	   else
	   begin//{
            read_enable      = ~fifo_empty;
            txn_id_w         = id;
	    awaddr           = addr;
	    awlen            = len;
	    awsize           = size;
	    awburst          = burst;
	    awlock           = lock;
	    awcache          = cache;
	    awprot           = prot;
	    wstrb            = strobe;
	    wdata            = fifo_rdata[63:0];
           mpl_with_eop_inst = mpl_with_eop - 'd64;

	   end//}
       end//}
       
       PROC_DATA:
         begin//{
         if(mpl_with_eop_inst < 'd64)
         begin//{
           if (count == 'd0)//first_half = 1//first half is getting transferred 
	   begin//{
             if(('d56 < max_payload) && (max_payload <= 'd64)) 
             begin//{
            if (max_payload == 'd57)
	    begin//{
              eop_reg   = {eop_reg_1 ,fifo_rdata[127]};
            end//}
            else if (max_payload == 'd58)
	    begin//{
              eop_reg   = {eop_reg_1 ,fifo_rdata[127 :126]};
            end//}
            else if (max_payload == 'd59)
	    begin//{
              eop_reg   = {eop_reg_1 ,fifo_rdata[127 :125]};
            end//}
            else if (max_payload == 'd60)
	    begin//{
              eop_reg   = {eop_reg_1 ,fifo_rdata[127 :124]};
            end//}
            else if (max_payload == 'd61)
	    begin//{
              eop_reg    = {eop_reg_1 ,fifo_rdata[127 : 123]};
            end//}
            else if (max_payload == 'd62)
	    begin//{
              eop_reg   = {eop_reg_1 ,fifo_rdata[127 :122]};
            end//}
            else if (max_payload == 'd63)
	    begin//{
              eop_reg   = {eop_reg_1 ,fifo_rdata[127: 121]};
            end//}
	    else 
	    begin//{
              eop_reg   = {fifo_rdata[127: 120]};
            end//}


	      if ( eop_flag != (eop_reg == 'h53))
	      begin//{
	        err_flag = 1'b1;
		wr_trn_en = 1'b0;

	      end//}
	      else
	      begin//{
	        err_flag = 1'b0;
         	wr_trn_en = 1'b0;

	      end//}
	      
	      // read_enable = ~fifo_empty;
	     end//]
	     else // this condition is not there (('d56 < max_payload) && (max_payload <= 'd64)) 
	     begin//{
               wr_trn_en = 1'b1;
               wdata =  fifo_rdata[127 : 64];//(136 - (mpl_with_eop_inst))];
	       eop_flag = (fifo_rdata [127:120] == 'h53)||
                          (fifo_rdata [119:112] == 'h53)||
                          (fifo_rdata [111:104] == 'h53)||
                          (fifo_rdata [103:96]  == 'h53)||
                          (fifo_rdata [95:88]   == 'h53)||
                          (fifo_rdata [87:80]   == 'h53)||
                          (fifo_rdata [79:72]   == 'h53)||
                          (fifo_rdata [71:64]  == 'h53);


		          

	     // eop_reg = fifo_rdata [(135 - (mpl_with_eop_inst)) :(128 - (mpl_with_eop_inst))];
		  		     
              if ( eop_flag != (eop_reg == 'h53))
	      begin//{
	        err_flag = 1'b1;
                wr_trn_en = 1'b0;
	      end//}
	      else
	      begin//{
	        err_flag = 1'b0;
                wr_trn_en = 1'b0;


	      end//}
              end //}
	        read_enable = ~fifo_empty;
	      //end//}
            end//}//end of first half condition 
            
	    
	    else //second half is getting transfered 
	    begin//{
	      wr_trn_en = 1'b1;
	      wdata = fifo_rdata[63 : 0];//(72 -(mpl_with_eop_inst))];
              eop_flag = (fifo_rdata [63:56]   == 'h53)||
                          (fifo_rdata [55: 48] == 'h53)||
                          (fifo_rdata [47 : 40]== 'h53)||
                          (fifo_rdata [39 : 32]== 'h53)||
                          (fifo_rdata [31: 24] == 'h53)||
                          (fifo_rdata [23: 16] == 'h53)||
                          (fifo_rdata [15: 8]  == 'h53)||
                          (fifo_rdata [7: 0]   == 'h53);


              if ( eop_flag != (eop_reg == 'h53))
	      begin//{
	        err_flag = 1'b1;
                wr_trn_en = 1'b0;
	      end//}
	      else
	      begin//{
	        err_flag = 1'b0;
                wr_trn_en = 1'b0;


	      end//}


	      //eop_flag = fifo_rdata[(71 -(mpl_with_eop_inst)) :(64 -(mpl_with_eop_inst))];
	      count = 'd0;
              read_enable = ~fifo_empty;
	    end//} 
            end//}//end of(mpl_with_eop_inst < 'd64)

           else//(mpl_with_eop_inst > 'd64)
           begin//{
             if (count == 'd0)//first_half = 1//first half is getting transferred 
	     begin//{
               wr_trn_en = 1'b1;
               wdata =  fifo_rdata[127 : 64];
               mpl_with_eop_inst = mpl_with_eop - 'd64;
	       count = count + 'd1;
	     end//}
	      else //second half is getting transfered 
	      begin//{
                wr_trn_en = 1'b1;
	        wdata = fifo_rdata[63:0];
                mpl_with_eop_inst = mpl_with_eop - 'd64;
                read_enable  = ~fifo_empty;
	           
	     end//}
	    end//}
            end////end of proc_data case 
             

        WAIT_DATA:
	begin//{
          read_enable = ~fifo_empty;
	 end//}
       endcase//}
    end//}
   
        assign write_enable = wr_rsp_en ? 1'b1 :1'b0;
        assign write_data   = wr_rsp_en ? {104'd0 , 8'hAA , bid , bresp , 8'h53} : 128'd0;
 endmodule

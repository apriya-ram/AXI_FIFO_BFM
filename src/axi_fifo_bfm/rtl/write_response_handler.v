module write_response_handler #(
						parameter  id_wid   = 4
						)

							(   input                   clk,
                                input                   rst_n,
                                input 					wr_rsp_en,
							    input [id_wid-1:0]     	bid,
							    input [1:0]             bresp,
								input                   fifo_full,				   
								output reg              write_enable,
								output reg [127:0]      fifo_wdata
							                       
);

localparam w_INIT		   = 2'b00;
localparam GET_BID         = 2'b01;
localparam GET_BRESP 	   = 2'b10;

localparam  SOP        = 8'hAA;
localparam  EOP        = 8'h53;	   
		   


//decoder-AXI4 master interface	
reg[1:0]            wrsp_present_state;
reg[1:0]            wrsp_next_state;

reg[id_wid-1:0]     bid_int;
reg[3:0]            bresp_int; 

reg                 write_wr_rsp_packet;
		   

//write Response Handling
//control state machine 
always @ (posedge clk or negedge rst_n)  begin 
    if (rst_n == 1'b0) begin
      wrsp_present_state <= w_INIT;
    end else begin
      wrsp_present_state <= wrsp_next_state;
    end
end

always @(*) begin
	case(wrsp_present_state) 
	    w_INIT : begin
					if(wr_rsp_en == 1'b1) begin
						wrsp_next_state = GET_BRESP;
					end else begin
						wrsp_next_state = w_INIT;
					end	
					write_wr_rsp_packet = 1'b0;
					bid_int = 4'h0;
					bresp_int = 4'h0;					
			    end
		//GET_BID : begin
		//			bid_int = bid;
		//			wrsp_next_state = GET_BRESP;			
		//		  end
		GET_BRESP : begin
					    bid_int = bid;
						bresp_int = bresp;
						write_wr_rsp_packet = 1'b1;
						wrsp_next_state = w_INIT;
						
				    end
    endcase
end

always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 1'b0) begin
	    fifo_wdata <= {128{1'b0}};
		write_enable <= 1'b0;
	end else begin
		if(!fifo_full) begin
		    if (write_wr_rsp_packet == 1'b1) begin			
				write_enable <= 1'b1;
				fifo_wdata <= {SOP, bid_int, bresp_int, EOP, 104'h0};
						
			end else begin
			    write_enable <= 1'b0;
				fifo_wdata <= fifo_wdata;
			end
	   end else begin
	       write_enable <= 1'b0;
	       fifo_wdata <= fifo_wdata;
	   end
    end
    
end	
endmodule



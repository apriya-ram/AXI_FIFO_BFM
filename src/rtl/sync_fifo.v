module sync_fifo # 
( 
   parameter WIDTH      = 128,
   parameter DEPTH      = 4096,
   localparam ADDR_WIDTH = $clog2(DEPTH)
)
(
//inputs to fifo
input clk,rst,
input wr_en,rd_en,
input [WIDTH-1:0]wr_data,

//outputs from fifo
output  empty,full,
output reg [WIDTH-1:0]rd_data
);

//internal registers
reg [WIDTH-1:0] mem[0:DEPTH-1];
reg [ADDR_WIDTH-1:0]rd_ptr;
reg [ADDR_WIDTH-1:0]wr_ptr;
reg [ADDR_WIDTH-1:0]rd_ptr_nxt;
reg [ADDR_WIDTH-1:0]wr_ptr_nxt;
reg [ADDR_WIDTH-1:0]counter;

//........assigning empty and full condition ........

assign empty =(counter==0);
assign full =(counter==DEPTH);

//...............fifo write process................
 
always @ (posedge clk or negedge rst)
begin 
    if (!rst) begin
      wr_ptr<='d0;    
    end else begin
      if(wr_en && !full)       //FIFO Write logic
      begin
          mem[wr_ptr]<=wr_data;
          wr_ptr<=wr_ptr+1;          
      end      
	end
end

//...............fifo read process................

always @ (posedge clk or negedge rst)
begin 
    if (!rst) begin      
      rd_ptr<='d0;      
    end else begin
       if(rd_en  && !empty)     //FIFO Read logic
       begin 
          rd_data<= mem[rd_ptr];
          rd_ptr<=rd_ptr+1;          
       end     
	end
end

//.............. counter process.................

always @ (posedge clk or negedge rst)
begin 
    if (!rst) begin
		counter <= 0;
	end else begin
		case ({wr_en,rd_en})
			2'b10 : counter <= counter + 1;
			2'b01 : counter <= counter - 1;
			2'b11 : counter <= counter;
			2'b10 : counter <= counter;		
		endcase
	end
end	
endmodule     



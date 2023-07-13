`define AXI_HANDSHAKING_SEQ_INCLUDED_
`ifndef AXI_HANDSHAKING_SEQ_INCLUDED_

class axi_handshaking_seq extends fifo_bfm_base_seq;


//      factory Registration

        `uvm_object_utils(axi_handshaking_seq)

//      Declare the AXI packet

        axi_packet pkt;

//...............................................................................................

//      Externally defned function

//...............................................................................................

        extern function new(string name="axi_handshaking_seq");
        extern task body();

endclass:axi_handshaking_seq

//...............................................................................................
//      Constructor new: 
//      Initialises the fifosequence class object

//      parameters:
//      name:axi_handshaking_seq
//...............................................................................................
function axi_handshaking_seq :: new (string name = "axi_handshaking_seq");
        super.new(name);
endfunction:new

task axi_handshaking_seq::body();
                super.body();
                pkt = axi_handshaking_seq :: type_id :: create("pkt");
                start.item(pkt);
                if(AxVALID==1 && AxREADY==1)begin

                        property valid_b_ready
                        @(posedge clk)
                                $rose (valid) |=> $rose(ready);
                        endproperty
                end

                else if (AxREADY==1 && AxVALID==0) begin
                        property ready_b_valid
                        @(posedge clk)
                                $rose (ready) |=> $rose (vaid);
                        endproperty
                end

                else if (AxREADY==1 && AxVALID==1)
                        property ready_with_valid
                        @ (posedge clk)
                                $rose (AXREADY) |=> [0:n] $rose (AxVALID);
                        endproperty
                end

        finsh_item(pkt);
        end
endtask:body

`endif




`ifndef AXI_FIFO_SCOREBOARD_INCLUDED_
`define AXI_FIFO_SCOREBOARD_INCLUDED_
//--------------------------------------------------------------------------------------------
// Class: axi_fifo_scoreboard 
// Description:
// This scoreboard for write txn, it compares fifo packet as expected and axi slave signals converted to fifo seq item as actual.  
//--------------------------------------------------------------------------------------------

class axi_fifo_scoreboard extends uvm_scoreboard;

`uvm_component_utils(axi_fifo_scoreboard);

write_fifo_seq_item packet_tx_fifo_agent_q[$];
//write_fifo_seq_item packet_rx_fifo_agent_q[$];

`uvm_analysis_imp_decl(_from_tx_fifo_agent)
uvm_analysis_imp_from_tx_fifo_agent #(write_fifo_seq_item, axi_fifo_scoreboard) from_tx_fifo_agent;

//`uvm_analysis_imp_decl(_from_rx_fifo_agent)
//uvm_analysis_imp_from_rx_fifo_agent#(read_fifo_seq_item, axi_fifo_scoreboard) from_rx_fifo_agent;

`uvm_analysis_imp_decl(_avip_slave_write_add_exp)
//uvm_analysis_imp_avip_slave_write_add_exp #(write_fifo_seq_item, axi_fifo_scoreboard) avip_slave_write_add_exp;
uvm_analysis_imp_avip_slave_write_add_exp #(axi4_slave_tx, axi_fifo_scoreboard) avip_slave_write_add_exp;

`uvm_analysis_imp_decl(_avip_slave_write_data_exp)
uvm_analysis_imp_avip_slave_write_data_exp #(axi4_slave_tx, axi_fifo_scoreboard) avip_slave_write_data_exp;

`uvm_analysis_imp_decl(_avip_slave_write_res_exp)
uvm_analysis_imp_avip_slave_write_res_exp #(axi4_slave_tx, axi_fifo_scoreboard) avip_slave_write_res_exp;

`uvm_analysis_imp_decl(_avip_slave_read_add_exp)
uvm_analysis_imp_avip_slave_read_add_exp #(axi4_slave_tx, axi_fifo_scoreboard) avip_slave_read_add_exp;

`uvm_analysis_imp_decl(_avip_slave_read_data_exp)
uvm_analysis_imp_avip_slave_read_data_exp #(axi4_slave_tx, axi_fifo_scoreboard) avip_slave_read_data_exp;


function new(string name, uvm_component parent);
super.new(name, parent);
from_tx_fifo_agent= new("from_tx_fifo_agent", this);
avip_slave_write_add_exp= new("avip_slave_write_add_exp", this);
avip_slave_write_data_exp= new("avip_slave_write_data_exp", this);
avip_slave_write_res_exp= new("avip_slave_write_res_exp", this);
avip_slave_read_add_exp= new("avip_slave_read_add_exp", this);
avip_slave_read_data_exp= new("avip_slave_read_data_exp", this);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);

endfunction

virtual function void write_from_tx_fifo_agent(write_fifo_seq_item tx_pkt);
$display("PK: SCB Recieved pkt from tx_fifo_packet len:%0h,strb:%0h",tx_pkt.awlen,tx_pkt.wstrb);
tx_pkt.print();
//`uvm_info(get_name(), $printf("SCB Recieved pkt from tx_fifo_packet", UVM_HIGH))
packet_tx_fifo_agent_q.push_back(tx_pkt);
$display("PK: SCB QUEUE Recieved pkt from tx_fifo_packet len:%h",packet_tx_fifo_agent_q.size());
endfunction

//virtual function void write_from_rx_fifo_agt(seq_item rx_pkt);
//`uvm_info(get_name(), $printf("Recieved pkt from rx_fifo_packet", UVM_HIGH))
//rx_pkt.print();
//write_fifo_seq_item.addr = rx_pkt.awaddr
//actual.push_back(new_pkt);
//check_rx_fifo_packet_event.trigger();
//endfunction

virtual function void write_avip_slave_write_add_exp(axi4_slave_tx rx_pkt);
$display("PK: SCB Recieved pkt from SLAVE WRITE ADDR packet");
`uvm_info("SCB", $sformatf("write addr slave_seq = \n%s",rx_pkt.sprint()), UVM_NONE);
$display("PK: SCB Recieved pkt from SLAVE WRITE ADDR packet len:%0h,addr:%0h",rx_pkt.awlen,rx_pkt.awaddr);
//`uvm_info(get_name(), $printf("SCB Recieved pkt from tx_fifo_packet", UVM_HIGH))
//packet_tx_fifo_agent_q.push_back(tx_pkt);
//$display("PK: SCB QUEUE Recieved pkt from tx_fifo_packet len:%h",packet_tx_fifo_agent_q.size());
endfunction

virtual function void write_avip_slave_write_data_exp(axi4_slave_tx rx_pkt);
$display("PK: SCB Recieved pkt from SLAVE WRITE DATA packet");
$display("PK: SCB Recieved pkt from SLAVE WRITE DATA packet len:%0h,addr:%0h",rx_pkt.awlen,rx_pkt.awaddr);
//`uvm_info(get_name(), $printf("SCB Recieved pkt from tx_fifo_packet", UVM_HIGH))
//packet_tx_fifo_agent_q.push_back(tx_pkt);
//$display("PK: SCB QUEUE Recieved pkt from tx_fifo_packet len:%h",packet_tx_fifo_agent_q.size());
endfunction


virtual function void write_avip_slave_write_res_exp(axi4_slave_tx rx_pkt);
$display("PK: SCB Recieved pkt from SLAVE WRITE RESP packet");
$display("PK: SCB Recieved pkt from SLAVE WRITE RESP packet len:%0h,addr:%0h",rx_pkt.awlen,rx_pkt.awaddr);
//`uvm_info(get_name(), $printf("SCB Recieved pkt from tx_fifo_packet", UVM_HIGH))
//packet_tx_fifo_agent_q.push_back(tx_pkt);
//$display("PK: SCB QUEUE Recieved pkt from tx_fifo_packet len:%h",packet_tx_fifo_agent_q.size());
endfunction


virtual function void write_avip_slave_read_add_exp(axi4_slave_tx rx_pkt);
$display("PK: SCB Recieved pkt from SLAVE READ ADDR packet");
$display("PK: SCB Recieved pkt from SLAVE READ ADDR packet len:%0h,addr:%0h",rx_pkt.awlen,rx_pkt.awaddr);
//`uvm_info(get_name(), $printf("SCB Recieved pkt from tx_fifo_packet", UVM_HIGH))
//packet_tx_fifo_agent_q.push_back(tx_pkt);
//$display("PK: SCB QUEUE Recieved pkt from tx_fifo_packet len:%h",packet_tx_fifo_agent_q.size());
endfunction


virtual function void write_avip_slave_read_data_exp(axi4_slave_tx rx_pkt);
$display("PK: SCB Recieved pkt from SLAVE READ DATA packet");
$display("PK: SCB Recieved pkt from SLAVE READ DATA packet len:%0h,addr:%0h",rx_pkt.awlen,rx_pkt.awaddr);
//`uvm_info(get_name(), $printf("SCB Recieved pkt from tx_fifo_packet", UVM_HIGH))
//packet_tx_fifo_agent_q.push_back(tx_pkt);
//$display("PK: SCB QUEUE Recieved pkt from tx_fifo_packet len:%h",packet_tx_fifo_agent_q.size());
endfunction

endclass
`endif


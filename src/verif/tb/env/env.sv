`ifndef ENV_INCLUDED_
`define ENV_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi env
// Description:
// Environment contains write_fifo_agent and scoreboard
//--------------------------------------------------------------------------------------------
class env extends uvm_env;
  `uvm_component_utils(env)
  
  write_fifo_agent write_fifo_agent_h;
  //read_fifo_agent read_fifo_agent_h;
  axi4_slave_agent axi_slave_agent_h;
  axi_fifo_scoreboard axi_fifo_scoreboard_h;

  function new(string name = "axi_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

   virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);

     write_fifo_agent_h = write_fifo_agent::type_id::create("write_fifo_agent_h",this);
     //read_fifo_agent_h = read_fifo_agent::type_id::create("read_fifo_agent_h",this);
     axi_slave_agent_h = axi4_slave_agent::type_id::create("axi_slave_agent_h",this);
     axi_fifo_scoreboard_h = axi_fifo_scoreboard::type_id::create("axi_fifo_scoreboard_h",this);

   endfunction

   virtual function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     
     write_fifo_agent_h.write_fifo_monitor_h.item_collected_port.connect(axi_fifo_scoreboard_h.from_tx_fifo_agent);
     //read_fifo_agent_h.fifo_bfm_r_monitor.item_collected_port.connect(axi_fifo_scoreboard_h.from_rx_fifo_agent);
     axi_slave_agent_h.axi4_slave_mon_proxy_h.axi4_slave_write_address_analysis_port.connect(axi_fifo_scoreboard_h.avip_slave_write_add_exp);
     axi_slave_agent_h.axi4_slave_mon_proxy_h.axi4_slave_write_data_analysis_port.connect(axi_fifo_scoreboard_h.avip_slave_write_data_exp);
     axi_slave_agent_h.axi4_slave_mon_proxy_h.axi4_slave_write_response_analysis_port.connect(axi_fifo_scoreboard_h.avip_slave_write_res_exp);
     axi_slave_agent_h.axi4_slave_mon_proxy_h.axi4_slave_read_address_analysis_port.connect(axi_fifo_scoreboard_h.avip_slave_read_add_exp);
     axi_slave_agent_h.axi4_slave_mon_proxy_h.axi4_slave_read_data_analysis_port.connect(axi_fifo_scoreboard_h.avip_slave_read_data_exp);

   endfunction

endclass 
`endif

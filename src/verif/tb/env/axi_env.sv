`ifndef AXI_ENV_INCLUDED_
`define AXI_ENV_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi env
// Description:
// Environment contains wr`:```:ite_fifo_agent and scoreboard
//--------------------------------------------------------------------------------------------
class axi_env extends uvm_env;
  `uvm_component_utils(axi_env)
  
  //Variable : axi_env_cfg_h
  //Declaring handle for axi_env_config_object
  //axi_env_config axi_env_cfg_h;

  //Variable : write_fifo_agent_h
  //Declaring write fifo agent handle 
  write_fifo_agent write_fifo_agent_h;

  //Variable : read_fifo_agent_h
  //Declaring write fifo agent handle 
  read_fifo_agent read_fifo_agent_h;

  //Variable : axi_slave_agent_h
  //Declaring write fifo agent handle 
  axi4_slave_agent axi_slave_agent_h;

  //Variable : axi_scoreboard_h
  //Declaring axi scoreboard handle
  //axi_scoreboard axi_scoreboard_h;

 
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi_env", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : axi_env

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
// name - axi_env
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function axi_env::new(string name = "axi_env",uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// Description:
// Create required components
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi_env::build_phase(uvm_phase phase);
  super.build_phase(phase);

  write_fifo_agent_h = write_fifo_agent::type_id::create("write_fifo_agent",this);
  read_fifo_agent_h = read_fifo_agent::type_id::create("read_fifo_agent",this);
  axi_slave_agent_h = axi4_slave_agent::type_id::create("axi_slave_agent",this);
  //axi_scoreboard_h = axi_scoreboard::type_id::create("write_fifo_agent",this);

/*
  if(!uvm_config_db #(axi_env_config)::get(this,"","axi_env_config",axi_env_cfg_h)) begin
    `uvm_fatal("FATAL_ENV_CONFIG", $sformatf("Couldn't get the env_config from config_db"))
  end
  */  
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
// Description:
// To connect driver and sequencer
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
/*
  write_fifo_agent_h.monitor.item_collected_port.connect(axi_scoreboard_h.item_collected_export);
  read_fifo_agent_h.read_monitor.item_collected_port1.connect(axi_scoreboard_h.item_collected_export);
  axi_slave_agent_h.slave_monitor.item_collected_port2.connect(axi_scoreboard_h.item_collected_export);
*/
 endfunction : connect_phase

`endif


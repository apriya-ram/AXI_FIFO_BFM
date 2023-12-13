class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils (fifo_scoreboard)
  uvm_analysis_export #(seq_item) write_export;
  uvm_analysis_export #(seq_item) read_export;
  function new (string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction : new
  virtual function void build_phase (uvm_phase phase);
    write_export = new("write_export", this);
    read_export = new("read_export", this);
  endfunction : build_phase
   ///compare_logic///
endclass
 
//////////////////////////write_agent/////////////////////////
//typedef uvm_sequencer #(seq_item) write_seqr;
 
class write_agent extends uvm_agent;
  `uvm_component_utils (write_agent)
 
   wr_driver    wr_driver;
   write_monitor   wr_monitor;
   write_seqr wr_sequencer;
 
  function new (string name = "write_agent", uvm_component parent);
     super.new (name, parent);
  endfunction
 
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
       wr_driver    = wr_driver::type_id::create("wr_driver"   , this);
       wr_sequencer = write_seqr::type_id::create("wr_sequencer", this);
    wr_monitor = write_monitor::type_id::create("wr_monitor", this);
  endfunction
 
  virtual function void connect_phase (uvm_phase phase);         wr_driver.seq_item_port.connect(wr_sequencer.seq_item_export);
  endfunction
 
endclass
 
//////////////////////////read_agent/////////////////////////
//typedef uvm_sequencer #(seq_item) read_seqr;
 
class read_agent extends uvm_agent;
  `uvm_component_utils (read_agent)
 
   r_driver    rd_driver;
   r_monitor   rd_monitor;
   read_seqr rd_sequencer;
 
  function new (string name = "read_agent", uvm_component parent);
     super.new (name, parent);
  endfunction
 
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    rd_driver    = r_driver::type_id::create("rd_driver"   , this);
    rd_sequencer = read_seqr::type_id::create("rd_sequencer", this);
 
    rd_monitor = r_monitor::type_id::create("rd_monitor", this);
  endfunction
 
  virtual function void connect_phase (uvm_phase phase);         rd_driver.seq_item_port.connect(rd_sequencer.seq_item_export);
  endfunction
 
endclass
//////////////////////////fifo_environment///////////////////////////
 
class fifo_environment extends uvm_env;
  `uvm_component_utils (fifo_environment)
 
   write_agent     wr_agent;
   read_agent      rd_agent;
   fifo_scoreboard      fifo_sbd;
 
  function new (string name = "fifo_environment", uvm_component parent);
    super.new (name, parent);
  endfunction
 
  virtual function void build_phase (uvm_phase phase);
    wr_agent = write_agent::type_id::create("wr_agent", this);
    rd_agent  = read_agent ::type_id::create("rd_agent" , this);
    fifo_sbd = fifo_scoreboard::type_id::create("fifo_sbd", this);
  endfunction
  virtual function void connect_phase (uvm_phase phase);
    wr_agent.wr_monitor.write_mon_ap.connect(fifo_sbd.write_export);
    rd_agent.rd_monitor.read_mon_ap.connect(fifo_sbd.read_export);
  endfunction
 
endclass
 
 
/////////////////////////write_test//////////////////////////////////
 
class write_test extends uvm_test;
  `uvm_component_utils(write_test)
 
	fifo_environment fifo_env;
    write_seq wr_seq;
 
  function new(string name = "write_test", uvm_component parent = null);
  	super.new(name, parent);
  endfunction
 
  function void build_phase(uvm_phase phase);
    wr_seq = write_seq::type_id::create("wr_seq");
    fifo_env = fifo_environment::type_id::create("fifo_env",this); 
  endfunction
  task run_phase (uvm_phase phase);  
    phase.raise_objection(this);
    wr_seq.start(fifo_env.wr_agent.wr_sequencer);       
    phase.drop_objection(this);
endtask
endclass
 
////////////////////////////////////////////////////////////
 
 
/////////////////////////read_test//////////////////////////////////
 
class read_test extends uvm_test;
  `uvm_component_utils(read_test)
 
	fifo_environment fifo_env;
    read_seq rd_seq;
 
  function new(string name = "read_test", uvm_component parent = null);
  	super.new(name, parent);
  endfunction
 
  function void build_phase(uvm_phase phase);
    rd_seq = read_seq::type_id::create("rd_seq");
    fifo_env = fifo_environment::type_id::create("fifo_env",this); 
  endfunction
  task run_phase (uvm_phase phase);  
    phase.raise_objection(this);
    rd_seq.start(fifo_env.rd_agent.rd_sequencer);       
    phase.drop_objection(this);
endtask
endclass

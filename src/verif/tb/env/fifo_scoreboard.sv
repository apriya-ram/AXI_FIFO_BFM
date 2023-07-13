class fifo_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(fifo_scoreboard)
  //---------------------------------------
  //Analysis import declaration
  //---------------------------------------
  uvm_analysis_imp#(fifo_sequence_item, fifo_scoreboard) mon_imp;
  
  fifo_sequence_item que[$];
  bit [7:0]mem[7:0];
  
  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name,parent);
    i=0;
    j=0;
    mon_imp = new("mon_imp", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  //---------------------------------------
  //Write function implemetation
  //---------------------------------------
 function void write(fifo_sequence_item trans);
   que.push_back(trans); 
  endfunction 
  int i,j;
  virtual task run_phase(uvm_phase phase);
    forever begin
    fifo_sequence_item wr_trans;
    wait(que.size()>0);
      wr_trans=que.pop_front();
      if(wr_trans.wr==1) begin
        mem[i]=wr_trans.data_in;
        i++;
        end
      else if(wr_trans.rd==1&&!wr_trans.empty) begin
        if(wr_trans.data_out==mem[j]) begin
        `uvm_info(get_type_name(),$sformatf("------ :: EXPECTED MATCH:: ------"),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Data: %0h,mem[%0d]=%0h",wr_trans.data_out,j,mem[j]),UVM_LOW)
        end
      else begin
          `uvm_info(get_type_name(),$sformatf("------ :: FAILED MATCH:: ------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Data: %0h,mem[%0d]=%0h",wr_trans.data_out,j,mem[j]),UVM_LOW)
    end
        j++;
        end
    end
  endtask
  
endclass


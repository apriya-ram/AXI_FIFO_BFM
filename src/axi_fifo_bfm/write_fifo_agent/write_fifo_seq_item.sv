`ifndef WRITE_FIFO_SEQ_ITEM_INCLUDED_
`define WRITE_FIFO_SEQ_ITEM_INCLUDED_

class write_fifo_seq_item extends uvm_sequence_item;
  const bit [7:0] SOP=8'b10101010;
  const bit [7:0] EOP=8'b01010011;

  typedef enum bit{write_addr_phase_pkt=0,read_addr_phase_pkt=1} type_of_pkt_e;
  rand type_of_pkt_e type_of_pkt;
 
  // write signals
   rand bit[31:0] awaddr;
   rand bit[DATA_WIDTH-1:0] wdata[$];
   rand bit[3:0] wstrb;
   rand bit[3:0] awlen;
   rand awid_e awid;
   rand awsize_e awsize;
   rand awburst_e awburst;
   rand awlock_e awlock;
   rand awcache_e awcache;
   rand awprot_e awprot;

   // read signals
   rand bit[31:0] araddr;
   rand bit[3:0] arlen;
   rand arid_e arid;
   rand arsize_e arsize;
   rand arburst_e arburst;
   rand arlock_e arlock;
   rand arcache_e arcache;
   rand arprot_e arprot;

    `uvm_object_utils_begin(write_fifo_seq_item)
    `uvm_field_enum(awid_e,awid,UVM_DEFAULT);
    `uvm_field_enum(awsize_e,awsize,UVM_DEFAULT);
    `uvm_field_enum(awburst_e,awburst,UVM_DEFAULT);
    `uvm_field_enum(awlock_e,awlock,UVM_DEFAULT);
    `uvm_field_enum(awcache_e,awcache,UVM_DEFAULT);
    `uvm_field_enum(awprot_e,awprot,UVM_DEFAULT);
    `uvm_field_int(awlen,UVM_DEFAULT);
    `uvm_field_int(awaddr,UVM_DEFAULT);
    `uvm_field_queue_int(wdata,UVM_DEFAULT);
    `uvm_field_int(wstrb,UVM_DEFAULT);
    `uvm_field_enum(arid_e,arid,UVM_DEFAULT);
    `uvm_field_enum(arsize_e,arsize,UVM_DEFAULT);
    `uvm_field_enum(arburst_e,arburst,UVM_DEFAULT);
    `uvm_field_enum(arlock_e,arlock,UVM_DEFAULT);
    `uvm_field_enum(arcache_e,arcache,UVM_DEFAULT);
    `uvm_field_enum(arprot_e,arprot,UVM_DEFAULT);
    `uvm_field_int(arlen,UVM_DEFAULT);
    `uvm_field_int(araddr,UVM_DEFAULT);
    `uvm_field_enum(type_of_pkt_e,type_of_pkt,UVM_DEFAULT);
    `uvm_object_utils_end

  //-----------------------------------------
  // constraints for write transaction
  // ----------------------------------------

  //payload size which is equal to transfers length+1
    constraint wdata_size{wdata.size()==awlen+1;}

  //address issued by master is alligned to natural address boundry of write address channel
    constraint awaddr_alligned{soft awaddr%32==0;}

  // AXI4 size varies from 1byte of transfer to maximum upto 128bytes for write transfers
    constraint awsize_c1{soft awsize == (WRITE_1_BYTE || WRITE_2_BYTES || WRITE_4_BYTES || WRITE_8_BYTES || WRITE_16_BYTES ||
    WRITE_32_BYTES || WRITE_64_BYTES || WRITE_128_BYTES);}

  // constraint for lock signal in AXI4 it supports write normal access or write exclusive access
    constraint awlock_c1{soft awlock == (WRITE_NORMAL_ACCESS || WRITE_EXCLUSIVE_ACCESS);}

  // AXI4 protection signal constraint for write transfers
    constraint awprot_c1{soft awprot == (WRITE_NORMAL_SECURE_DATA ||
    WRITE_NORMAL_SECURE_INSTRUCTION || WRITE_NORMAL_NONSECURE_DATA ||
    WRITE_NORMAL_NONSECURE_INSTRUCTION || WRITE_PRIVILEGED_SECURE_DATA ||
    WRITE_PRIVILEGED_SECURE_INSTRUCTION || WRITE_PRIVILEGED_NONSECURE_DATA ||
    WRITE_PRIVILEGED_NONSECURE_INSTRUCTION);}

  // AXI4 cache signals supports bufferable,modifiable, write allocate and write other allocate
    constraint awcache_c1{soft awcache == (WRITE_BUFFERABLE || WRITE_MODIFIABLE ||
    WRITE_OTHER_ALLOCATE || WRITE_ALLOCATE);}

  // burst type increment,fixed or wrap type supported in AXI4 for write transfers 
    constraint awburst_c1{soft awburst == (WRITE_INCR || WRITE_FIXED || WRITE_WRAP);}

  // burst is not equal to write reserved for the write transfers
    constraint awburst_c2{awburst != WRITE_RESERVED;}

  //-----------------------------------------
  // constraints for read transaction
  // ----------------------------------------

  //address issued by master is alligned to natural address boundry of read address channel
    constraint araddr_alligned{soft araddr%32==0;}
  
  // AXI4 size varies from 1byte of transfer to maximum upto 128bytes for read transfers
    constraint arsize_c1{soft arsize == (READ_1_BYTE || READ_2_BYTES || READ_4_BYTES || READ_8_BYTES || READ_16_BYTES || 
    READ_32_BYTES || READ_64_BYTES || READ_128_BYTES);}
  
  // constraint for lock signal in AXI4 it supports read normal access or read exclusive access
    constraint arlock_c1{soft arlock == (READ_NORMAL_ACCESS || READ_EXCLUSIVE_ACCESS);}
  
  // AXI4 protection signal constraint for read transfers
    constraint arprot_c1{soft arprot == (READ_NORMAL_SECURE_DATA ||
    READ_NORMAL_SECURE_INSTRUCTION || READ_NORMAL_NONSECURE_DATA ||
    READ_NORMAL_NONSECURE_INSTRUCTION || READ_PRIVILEGED_SECURE_DATA ||
    READ_PRIVILEGED_SECURE_INSTRUCTION || READ_PRIVILEGED_NONSECURE_DATA ||
    READ_PRIVILEGED_NONSECURE_INSTRUCTION);}
  
  // AXI4 cache signals supports bufferable,modifiable, read allocate and read other allocate
    constraint arcache_c1{soft arcache == (READ_BUFFERABLE || READ_MODIFIABLE || 
    READ_OTHER_ALLOCATE || READ_ALLOCATE);}
  
  // burst type increment,fixed or wrap type supported in AXI4 for read transfers 
    constraint arburst_c1{soft arburst == (READ_INCR || READ_FIXED || READ_WRAP);}
  
  // burst is not equal to read reserved for the read transfers
    constraint arburst_c2{arburst != READ_RESERVED;}

  function new(string name="write_fifo_seq_item");
    super.new(name);
  endfunction

endclass




/*class write_fifo_seq_item extends uvm_sequence_item;
  const bit [7:0] SOP=8'b10101010;
  const bit [7:0] EOP=8'b01010011;
 
  // write signals
   rand bit[31:0] awaddr;
   rand bit[DATA_WIDTH-1:0] wdata[$];
   rand bit[3:0] wstrb;
   rand bit[3:0] awlen;
   //rand awid_e awid;
   rand bit[3:0] awid;//john changed
   rand awsize_e awsize;
   rand awburst_e awburst;
   //rand awlock_e awlock;
   rand bit[1:0] awlock;//john changed
   rand awcache_e awcache;
   rand awprot_e awprot;

   // read signals
   
   rand bit[31:0] araddr;
   rand bit[3:0] arlen;
   //rand arid_e arid;
   rand bit[3:0] arid;//john changed
   rand arsize_e arsize;
   rand arburst_e arburst;
   //rand arlock_e arlock;
   rand bit[1:0] arlock;//john changed
   rand arcache_e arcache;
   rand arprot_e arprot;


   typedef enum bit{write_addr_phase_pkt=0,read_addr_phase_pkt=1}type_of_pkt_e;
   rand type_of_pkt_e type_of_pkt;

    `uvm_object_utils_begin(write_fifo_seq_item)
    //`uvm_field_enum(awid_e,awid,UVM_DEFAULT);
    `uvm_field_int(awid,UVM_DEFAULT);//john changed
    `uvm_field_enum(awsize_e,awsize,UVM_DEFAULT);
    `uvm_field_enum(awburst_e,awburst,UVM_DEFAULT);
    //`uvm_field_enum(awlock_e,awlock,UVM_DEFAULT);
    `uvm_field_int(awlock,UVM_DEFAULT);//john changed
    `uvm_field_enum(awcache_e,awcache,UVM_DEFAULT);
    `uvm_field_enum(awprot_e,awprot,UVM_DEFAULT);
    `uvm_field_int(awlen,UVM_DEFAULT);
    `uvm_field_int(awaddr,UVM_DEFAULT);
    `uvm_field_queue_int(wdata,UVM_DEFAULT);
    `uvm_field_int(wstrb,UVM_DEFAULT);
    //`uvm_field_enum(arid_e,arid,UVM_DEFAULT);
    `uvm_field_int(arid,UVM_DEFAULT); //john changed
    `uvm_field_enum(arsize_e,arsize,UVM_DEFAULT);
    `uvm_field_enum(arburst_e,arburst,UVM_DEFAULT);
    //`uvm_field_enum(arlock_e,arlock,UVM_DEFAULT);
    `uvm_field_int(arlock,UVM_DEFAULT);//john changed
    `uvm_field_enum(arcache_e,arcache,UVM_DEFAULT);
    `uvm_field_enum(arprot_e,arprot,UVM_DEFAULT);
    `uvm_field_int(arlen,UVM_DEFAULT);
    `uvm_field_int(araddr,UVM_DEFAULT);
    `uvm_field_enum(type_of_pkt_e,type_of_pkt,UVM_DEFAULT);
    `uvm_object_utils_end

  // constraints for write signals
  /*
    constraint wdata_size{wdata.size()==awlen+1;}
    constraint awaddr_alligned{soft awaddr%32==0;}
    constraint awsize_c1{soft awsize == WRITE_2_BYTES;}
    constraint wstrb_c1{soft wstrb ==4'hf;}
    constraint awlen_c1{soft awlen ==2;}
    constraint awlock_c1{soft awlock == WRITE_NORMAL_ACCESS;}
    constraint awprot_c1{soft awprot == WRITE_NORMAL_SECURE_DATA;}
    constraint awcache_c1{soft awcache == WRITE_BUFFERABLE;}

  // constraints for read signals
    constraint araddr_alligned{soft araddr%32==0;}
    constraint arsize_c1{soft arsize == READ_2_BYTES;}
    constraint arlen_c1{soft arlen ==2;}
    constraint arlock_c1{soft arlock == READ_NORMAL_ACCESS;}
    constraint arprot_c1{soft arprot == READ_NORMAL_SECURE_DATA;}
    constraint arcache_c1{soft arcache == READ_BUFFERABLE;}
    */

  //-----------------------------------------
  // constraints for write transaction
  // ----------------------------------------

  //payload size which is equal to transfers length+1
/*    constraint wdata_size{wdata.size()==awlen+1;}

  //address issued by master is alligned to natural address boundry of write address channel
    constraint awaddr_alligned{soft awaddr%32==0;}

  // AXI4 size varies from 1byte of transfer to maximum upto 128bytes for write transfers
    constraint awsize_c1{soft awsize == (WRITE_1_BYTE || WRITE_2_BYTES || WRITE_4_BYTES || WRITE_8_BYTES || WRITE_16_BYTES ||
    WRITE_32_BYTES || WRITE_64_BYTES || WRITE_128_BYTES);}

  // constraint for lock signal in AXI4 it supports write normal access or write exclusive access
    constraint awlock_c1{soft awlock == (WRITE_NORMAL_ACCESS || WRITE_EXCLUSIVE_ACCESS);}

  // AXI4 protection signal constraint for write transfers
    constraint awprot_c1{soft awprot == (WRITE_NORMAL_SECURE_DATA ||
    WRITE_NORMAL_SECURE_INSTRUCTION || WRITE_NORMAL_NONSECURE_DATA ||
    WRITE_NORMAL_NONSECURE_INSTRUCTION || WRITE_PRIVILEGED_SECURE_DATA ||
    WRITE_PRIVILEGED_SECURE_INSTRUCTION || WRITE_PRIVILEGED_NONSECURE_DATA ||
    WRITE_PRIVILEGED_NONSECURE_INSTRUCTION);}

  // AXI4 cache signals supports bufferable,modifiable, write allocate and write other allocate
    constraint awcache_c1{soft awcache == (WRITE_BUFFERABLE || WRITE_MODIFIABLE ||
    WRITE_OTHER_ALLOCATE || WRITE_ALLOCATE);}

  // burst type increment,fixed or wrap type supported in AXI4 for write transfers 
    constraint awburst_c1{soft awburst == (WRITE_INCR || WRITE_FIXED || WRITE_WRAP);}

  // burst is not equal to write reserved for the write transfers
    constraint awburst_c2{awburst != WRITE_RESERVED;}

  //-----------------------------------------
  // constraints for read transaction
  // ----------------------------------------

  //address issued by master is alligned to natural address boundry of read address channel
    constraint araddr_alligned{soft araddr%32==0;}
  
  // AXI4 size varies from 1byte of transfer to maximum upto 128bytes for read transfers
    constraint arsize_c1{soft arsize == (READ_1_BYTE || READ_2_BYTES || READ_4_BYTES || READ_8_BYTES || READ_16_BYTES || 
    READ_32_BYTES || READ_64_BYTES || READ_128_BYTES);}
  
  // constraint for lock signal in AXI4 it supports read normal access or read exclusive access
    constraint arlock_c1{soft arlock == (READ_NORMAL_ACCESS || READ_EXCLUSIVE_ACCESS);}
  
  // AXI4 protection signal constraint for read transfers
    constraint arprot_c1{soft arprot == (READ_NORMAL_SECURE_DATA ||
    READ_NORMAL_SECURE_INSTRUCTION || READ_NORMAL_NONSECURE_DATA ||
    READ_NORMAL_NONSECURE_INSTRUCTION || READ_PRIVILEGED_SECURE_DATA ||
    READ_PRIVILEGED_SECURE_INSTRUCTION || READ_PRIVILEGED_NONSECURE_DATA ||
    READ_PRIVILEGED_NONSECURE_INSTRUCTION);}
  
  // AXI4 cache signals supports bufferable,modifiable, read allocate and read other allocate
    constraint arcache_c1{soft arcache == (READ_BUFFERABLE || READ_MODIFIABLE || 
    READ_OTHER_ALLOCATE || READ_ALLOCATE);}
  
  // burst type increment,fixed or wrap type supported in AXI4 for read transfers 
    constraint arburst_c1{soft arburst == (READ_INCR || READ_FIXED || READ_WRAP);}
  
  // burst is not equal to read reserved for the read transfers
    constraint arburst_c2{arburst != READ_RESERVED;}
   


  function new(string name="write_fifo_seq_item");
    super.new(name);
  endfunction

endclass*/
`endif

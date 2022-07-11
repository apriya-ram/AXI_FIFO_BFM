all:
	make clean; make sim; make clean;

VCS_CMD_RAND    = vcs -V -R  -full64 -sverilog +v2k -debug_access+all -ntb_opts uvm-1.2 -debug_pp +ntb_random_seed_automatic -override_timescale=1ps/1ps
 
sim:
	${VCS_CMD_RAND} \
	+incdir+../../src/verif/vip/axi_master_vip/ \
	+incdir+../../src/verif/bfm/write_fifo/ \
	+incdir+../../src/verif/tb/env/ \
  +incdir+../../src/verif/tb/test/  \
	+incdir+../../src/verif/vip/axi_slave_vip/ \
	+incdir+../../src/verif/bfm/read_fifo/ \
	+incdir+../../src/verif/bfm/write_fifo/fifo_interface \
	../../src/verif/bfm/write_fifo/fifo_interface/fifo_interface.sv \
	../../src/verif/tb/top.sv \
	../../src/verif/vip/axi_master_vip/
	../../src/verif/vip/axi_slave_vip/
	+UVM_VERBOSITY=MEDIUM \
	+plusarg_ignore \
	-l transcript_vcs.log

	#+incdir+/projects/UVM/uvm-1.2/src \
	#/projects/UVM/uvm-1.2/src/uvm_pkg.sv \

	#vsim -novopt work.hvl_top work.hdl_top -c -do "log -r /*; add wave -r /*; run -all;" \
	#-wlf waveform.wlf
	# To open the waveform use the below command 
	# vsim -view waveform.wlf &

clean:
	rm -rf work/ transcript waveform.wlf

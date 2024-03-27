-uvmhome "/eda/cadence/2019-20/RHELx86/XCELIUM_19.03.013/tools/methodology/UVM/CDNS-1.2/" 
-uvm +UVM_TESTNAME=test_hough_simple +UVM_VERBOSITY=UVM_LOW
-sv +incdir+../verif
-sv +incdir+../verif/agent
-sv +incdir+../verif/axi_agent
-sv +incdir+../verif/sequence
-sv +incdir+../verif/configuration

../dut/utils_pkg.vhd
../dut/bram.vhd
../dut/dsp_unit_1.vhd
../dut/dsp_unit_2.vhd
../dut/dsp_unit_3.vhd
../dut/dsp_unit_5.vhd
../dut/dsp_unit_7.vhd
../dut/dsp_unit_8.vhd
../dut/fsm.vhd
../dut/hough_core.vhd
../dut/Hough_IP_v1_0.vhd
../dut/Hough_IP_v1_0_S00_AXI.vhd
../dut/hough_structure.vhd
../dut/loop_pipeline_if.vhd
../dut/processing_unit.vhd
../dut/rom.vhd

-sv ../verif/configuration/configuration_pkg.sv
-sv ../verif/agent/hough_agent_pkg.sv
-sv ../verif/axi_agent/hough_axi_agent_pkg.sv
-sv ../verif/sequence/hough_sequence_pkg.sv
-sv ../verif/test_pkg.sv
-sv ../verif/hough_interface.sv
-sv ../verif/hough_top.sv

#-LINEDEBUG
-access +rwc
-disable_sem2009
-nowarn "MEMODR"
-timescale 1ns/10ps

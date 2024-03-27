cd ..
set root_dir [pwd]
cd scripts
set resultDir ../uvm_project

file mkdir $resultDir

create_project hough_verif $resultDir -part xc7z010clg400-1
set_property board_part digilentinc.com:zybo-z7-10:part0:1.0 [current_project]


# Ukljucivanje svih izvornih i simulacionih fajlova u projekat

add_files -norecurse ../dut/utils_pkg.vhd
add_files -norecurse ../dut/bram.vhd
add_files -norecurse ../dut/dsp_unit_1.vhd
add_files -norecurse ../dut/dsp_unit_2.vhd
add_files -norecurse ../dut/dsp_unit_3.vhd
add_files -norecurse ../dut/dsp_unit_5.vhd
add_files -norecurse ../dut/dsp_unit_7.vhd
add_files -norecurse ../dut/dsp_unit_8.vhd
add_files -norecurse ../dut/fsm.vhd
add_files -norecurse ../dut/hough_core.vhd
add_files -norecurse ../dut/Hough_IP_v1_0.vhd
add_files -norecurse ../dut/Hough_IP_v1_0_S00_AXI.vhd
add_files -norecurse ../dut/hough_structure.vhd
add_files -norecurse ../dut/loop_pipeline_if.vhd
add_files -norecurse ../dut/processing_unit.vhd
add_files -norecurse ../dut/rom.vhd

update_compile_order -fileset sources_1

set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/axi_agent/hough_axi_agent_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/agent/hough_agent_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/configuration/configuration_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/sequence/hough_sequence_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/test_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/hough_interface.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/hough_top.sv

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1


# Ukljucivanje uvm biblioteke

set_property -name {xsim.compile.xvlog.more_options} -value {-L uvm} -objects [get_filesets sim_1]
set_property -name {xsim.elaborate.xelab.more_options} -value {-L uvm} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.xsim.more_options} -value {-testplusarg UVM_TESTNAME=test_hough_simple -testplusarg UVM_VERBOSITY=UVM_LOW} -objects [get_filesets sim_1]
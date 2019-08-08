package require ::quartus::project
package require ::quartus::flow

set batch_folder "D:/Arch_Benchmark/Hunter_Wang/04_oc_usbhostslave/arri_batch"
set top_module "usbhostslave_wrapper"
set device_prefix "arri"

set case_size_list {
30
33
36
39
41
44
}

#14
#17
#20
#24
#27
#30
#32
#33
#34
 
set case_fmax_list {
300 {3.333}
310 {3.226}
320 {3.125}
330 {3.030}
340 {2.941}
350 {2.857}
360 {2.778}
370 {2.703}
380 {2.632}
}

foreach case_size $case_size_list {
foreach {case_fmax case_period} $case_fmax_list {

cd $batch_folder
puts "Size: $case_size Fmax: $case_fmax Period: $case_period"

set proj_name "arria_"
append proj_name $case_size
append proj_name "_"
append proj_name $case_fmax
set rev_name "usbhostslave_wrapper"
file mkdir $proj_name
cd $proj_name

set constraint_file_name "constraint_$case_fmax.sdc"
set constraint_file [open "./$constraint_file_name" w]
puts $constraint_file "create_clock -name \{clock\} -period 20 \[ get_ports \{clock\} \]"
puts $constraint_file "create_clock -name \{clk_core\} -period $case_period \[ get_ports \{clk_core\} \]"
puts $constraint_file "set_clock_groups -group \[get_clocks clock\] -group \[get_clocks clk_core\] -logically_exclusive"
close $constraint_file

project_new -revision $rev_name $proj_name
set_global_assignment -name FAMILY "Arria 10"
set_global_assignment -name DEVICE 10AX016E3F27E1HG
set_global_assignment -name TOP_LEVEL_ENTITY $top_module
set_global_assignment -name ORIGINAL_QUARTUS_VERSION 18.1.0
#set_global_assignment -name PROJECT_CREATION_TIME_DATE "18:51:29  MARCH 06, 2019"
set_global_assignment -name LAST_QUARTUS_VERSION "18.1.0 Standard Edition"
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
set_global_assignment -name DEVICE_FILTER_PIN_COUNT 672
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"

set_global_assignment -name SDC_FILE ./$constraint_file_name
#set_global_assignment -name VERILOG_FILE ../../wrap/dma_axi64_wrapper.v
#set_global_assignment -name VERILOG_FILE ../../dma_axi/src/dma_axi64/prgen_swap_64.v
#set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/include/timescale.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/buffers/RxFifo.v
#set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/include/wishBoneBus_h.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/buffers/RxFifoBI.v
#set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/include/usbSerialInterfaceEngine_h.v
#set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/include/usbConstants_h.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/serialInterfaceEngine/SIETransmitter.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/buffers/TxFifo.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/buffers/TxFifoBI.v
#set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/include/usbHostControl_h.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/hostController/USBHostControlBI.v
#set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/include/usbSlaveControl_h.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/slaveController/USBSlaveControlBI.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/hostController/directcontrol.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/buffers/dpMem_dc.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/slaveController/endpMux.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/slaveController/fifoMux.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/buffers/fifoRTL.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/hostController/getpacket.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/hostController/hctxportarbiter.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/hostSlaveMux/hostSlaveMux.v
#set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/include/usbHostSlave_h.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/hostSlaveMux/hostSlaveMuxBI.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/hostController/hostcontroller.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/serialInterfaceEngine/lineControlUpdate.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/serialInterfaceEngine/processRxBit.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/serialInterfaceEngine/processRxByte.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/serialInterfaceEngine/processTxByte.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/serialInterfaceEngine/readUSBWireData.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/hostController/rxStatusMonitor.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/slaveController/sctxportarbiter.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/hostController/sendpacket.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/hostController/sendpacketarbiter.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/hostController/sendpacketcheckpreamble.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/serialInterfaceEngine/siereceiver.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/slaveController/slaveDirectcontrol.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/slaveController/slaveGetpacket.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/slaveController/slaveRxStatusMonitor.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/slaveController/slaveSendpacket.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/slaveController/slavecontroller.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/hostController/sofcontroller.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/hostController/softransmit.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/serialInterfaceEngine/updateCRC16.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/serialInterfaceEngine/updateCRC5.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/hostController/usbHostControl.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/wrapper/usbHostSlave.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/serialInterfaceEngine/usbSerialInterfaceEngine.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/slaveController/usbSlaveControl.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/serialInterfaceEngine/usbTxWireArbiter.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/busInterface/wishBoneBI.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/serialInterfaceEngine/writeUSBWireData.v
set_global_assignment -name VERILOG_FILE ../../wrap/usbhostslave_wrapper.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/include/timescale.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/include/wishBoneBus_h.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/include/usbSerialInterfaceEngine_h.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/include/usbConstants_h.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/include/usbHostControl_h.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/include/usbSlaveControl_h.v
set_global_assignment -name VERILOG_FILE ../../usbhostslave/RTL/include/usbHostSlave_h.v
set_global_assignment -name SEARCH_PATH "../../usbhostslave/RTL/include"
#set_global_assignment -name VERILOG_INCLUDE_FILE ../../dma_axi/src/dma_axi64/dma_axi64_reg_params.v
#set_global_assignment -name VERILOG_INCLUDE_FILE ../../dma_axi/src/dma_axi64/dma_axi64_ch_reg_params.v
#set_global_assignment -name VERILOG_FILE ../../dma_axi/src/dma_axi64/dma_axi64_defines.v
set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT -section_id Top
set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
set_global_assignment -name VERILOG_SHOW_LMF_MAPPING_MESSAGES OFF
set_global_assignment -name VERILOG_MACRO "CORE_NUMS=$case_size"
set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top
# Commit assignments
export_assignments
exec quartus_map --read_settings_files=on --write_settings_files=off $proj_name -c $rev_name
exec quartus_fit --read_settings_files=off --write_settings_files=off $proj_name -c $rev_name
exec quartus_asm --read_settings_files=off --write_settings_files=off $proj_name -c $rev_name
exec quartus_sta $proj_name -c $rev_name
project_close
}
}

cd  $batch_folder

 

 

 

 
set batch_folder "D:/lshard0001/Arch_Benchmark/Hunter_Wang/02_oc_warp_tmu/ecp5_25K"
set top_module "tmu_wrapper"
set device_prefix "ecp5"
set case_size_list {
3
}

#4
#7
#10
#14
#17
#20
#23
#26
#28

set case_fmax_list {
90 {11.111}
}

#100 {10.000}
#110 {9.091}
#120 {8.333}
#130 {7.692}
#140 {7.143}
#150 {6.667}
#160 {6.250}
#180 {5.556}
#200 {5.000}

foreach case_size $case_size_list {
foreach {case_fmax case_period} $case_fmax_list {

cd $batch_folder
puts $case_fmax
puts $case_period

set proj_name $device_prefix\_$case_size\_$case_fmax

file mkdir $proj_name
cd $proj_name

set constraint_file_name "constraint_$case_fmax.sdc"
set constraint_file [open "./$constraint_file_name" w]

puts $constraint_file "create_clock -name \{clock\} -period 20 \[ get_ports \{clock\} \]"
puts $constraint_file "create_clock -name \{clk_core\} -period $case_period \[ get_ports \{clk_core\} \]"
puts $constraint_file "set_clock_groups -group \[get_clocks clock\] -group \[get_clocks clk_core\] -logically_exclusive"
close $constraint_file    

prj_project new -name $proj_name -impl "impl1" -dev LFE5U-25F-8MG285C -synthesis "synplify"
prj_src add "../../warp/source/tmu.v"
prj_src add "../../warp/source/tmu_addresses.v"
prj_src add "../../warp/source/tmu_burst.v"
prj_src add "../../warp/source/tmu_ctlif.v"
prj_src add "../../warp/source/tmu_decay.v"
prj_src add "../../warp/source/tmu_divider11.v"
prj_src add "../../warp/source/tmu_edgediv.v" 
prj_src add "../../warp/source/tmu_edgedivops.v"
prj_src add "../../warp/source/tmu_edgetrace.v"
prj_src add "../../warp/source/tmu_filter.v"
prj_src add "../../warp/source/tmu_meshgen.v"
prj_src add "../../warp/source/tmu_perfcounters.v"
prj_src add "../../warp/source/tmu_pixin.v"
prj_src add "../../warp/source/tmu_pixout.v"
prj_src add "../../warp/source/tmu_reorder.v"
prj_src add "../../warp/source/tmu_scandiv.v"
prj_src add "../../warp/source/tmu_scandivops.v"
prj_src add "../../warp/source/tmu_scantrace.v"
prj_src add "../../warp/tmu_wrapper.v"
prj_src add "./$constraint_file_name"

prj_impl option top $top_module
prj_impl option VERILOG_DIRECTIVES "CORE_NUMS=$case_size"
#prj_impl option {include path} "D:/Arch_Benchmark/Hunter_Wang/04_oc_usbhostslave/usbhostslave/RTL/include"
prj_project save
prj_run PAR -impl impl1 -task PARTrace
#if {[catch {prj_run PAR -impl impl1 -task PARTrace} err_msg]} {
	#prj_project close
	#continue
   #}
#prj_project close
}
}
cd $batch_folder
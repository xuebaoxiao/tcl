set batch_folder "D:/Arch_Benchmark/Hunter_Wang/03_oc_reed_solomon_decoder/Hunter_test_300k_1"
set top_module "reed_solomon_decoder_wrapper.v"
set device_prefix "kintu"

set case_size_list {
64
}
#52
#56
 
#17
#22
#22 crash @520

set case_fmax_list {
420 {2.381}
}

#370 {2.703}
#380 {2.632}
#390 {2.564}
#400 {2.500}
#410 {2.439}
 
#300 {3.333}
#320 {3.125}
#340 {2.941}
#360 {2.778}
#380 {2.632}

foreach case_size $case_size_list {
foreach {case_fmax case_period} $case_fmax_list {

cd $batch_folder

puts "Size: $case_size Fmax: $case_fmax Period: $case_period"

set proj_name $device_prefix
append proj_name "_"
append proj_name $case_size
append proj_name "_"
append proj_name $case_fmax

file mkdir $proj_name
cd $proj_name
 set constraint_file_name "constraint_$case_fmax.sdc"
 set constraint_file [open "./$constraint_file_name" w]
 puts $constraint_file "create_clock -name \{clock\} -period 20 \[ get_ports \{clock\} \]"
 puts $constraint_file "create_clock -name \{clk_core\} -period $case_period \[ get_ports \{clk_core\} \]"
 puts $constraint_file "set_clock_groups -group \[get_clocks clock\] -group \[get_clocks clk_core\] -logically_exclusive"
 close $constraint_file    

 create_project $proj_name ./$proj_name -part xcku035-fbva676-3-e
 add_files -norecurse {../../wrap/reed_solomon_decoder_wrapper.v}
 add_files -norecurse {../../reed_solomon_decoder/rtl_synplify/asc.vh}
 add_files -norecurse {../../reed_solomon_decoder/rtl_synplify/BM_lamda.v}
 add_files -norecurse {../../reed_solomon_decoder/rtl_synplify/dec.vh}
 add_files -norecurse {../../reed_solomon_decoder/rtl_synplify/DP_RAM.v}
 add_files -norecurse {../../reed_solomon_decoder/rtl_synplify/error_correction.v}
 add_files -norecurse {../../reed_solomon_decoder/rtl_synplify/GF_matrix_ascending_binary.v}
 add_files -norecurse {../../reed_solomon_decoder/rtl_synplify/GF_matrix_dec.v}
 add_files -norecurse {../../reed_solomon_decoder/rtl_synplify/GF_mult_add_syndromes.v}
 add_files -norecurse {../../reed_solomon_decoder/rtl_synplify/input_syndromes.v}
 add_files -norecurse {../../reed_solomon_decoder/rtl_synplify/lamda_roots.v}
 add_files -norecurse {../../reed_solomon_decoder/rtl_synplify/Omega_Phy.v}
 add_files -norecurse {../../reed_solomon_decoder/rtl_synplify/out_stage.v}
 add_files -norecurse {../../reed_solomon_decoder/rtl_synplify/RS_dec.v}
 add_files -norecurse {../../reed_solomon_decoder/rtl_synplify/transport_in2out.v}
 add_files -norecurse {../../reed_solomon_decoder/rtl_synplify/GF_matrix_ascending_binary.v}
 add_files -fileset constrs_1 -norecurse ./$constraint_file_name
 set_property verilog_define CORE_NUMS=$case_size [current_fileset]
 set_property top $top_module [current_fileset]
 save_project_as $proj_name ./ -exclude_run_results -force
set_param general.maxThreads 1
set_property IS_ENABLED true [get_report_config -of_object [get_runs impl_1] impl_1_place_report_timing_summary_0]
startgroup
set_property OPTIONS.setup true [get_report_config -of_objects [get_runs impl_1] impl_1_place_report_timing_summary_0]
set_property OPTIONS.hold true [get_report_config -of_objects [get_runs impl_1] impl_1_place_report_timing_summary_0]
endgroup
launch_runs synth_1
wait_on_run synth_1
launch_runs impl_1
wait_on_run impl_1
close_project
}
}

cd $batch_folder
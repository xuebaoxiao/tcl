set batch_folder "D:/Arch_Benchmark/Hunter_Wang/03_oc_reed_solomon_decoder/Hunter_test_300k_1"
set top_module "reed_solomon_decoder_wrapper"
set device_prefix "kintu"

set case_size_list {
52
56
64
}

#27
#54
#81
 
#22 crash @520

set case_fmax_list {
370 {2.703}
380 {2.632}
390 {2.564}
400 {2.500}
410 {2.439}
420 {2.381}
}

#440 {2.273}
#460 {2.174}
#480 {2.083}
#500 {2.000}

set buf "Core_Number,Target_Fmax,Target_Period,WNS_Place,Fmax_place,Real_WNS,Real_Fmax,LUT,Total_LUT,LUT%,REG,Total_REG,REG%,EBR,Total_EBR,EBR%,Slice,Total_Slice,Slice%,syn_runtime,syn_Memory,Placer_cpu,placer_elasped,elasped(P)_vs_cpu%,Placer_Memory,Router_cpu,Router_elasped,elasped(R)_vs_cpu%,Router_Memory\n"
foreach case_size $case_size_list {
foreach {case_fmax case_period} $case_fmax_list {
append buf $case_size
append buf ","
append buf $case_fmax
append buf ","
append buf $case_period
append buf ","
cd $batch_folder

set proj_name "$device_prefix\_$case_size\_$case_fmax"
cd $proj_name/$proj_name.runs/impl_1
puts "\n"
puts "design unit:$case_size, target Fmax:$case_fmax "

set fit_report_file_name $top_module
append fit_report_file_name "_utilization_placed.rpt"
set tsp_report_file_name $top_module
append tsp_report_file_name "_timing_summary_placed.rpt"
set tsr_report_file_name $top_module
append tsr_report_file_name "_timing_summary_routed.rpt"
set time_report_file_name $top_module
append time_report_file_name ".vdi"

####################tsp report##############################
#puts "Reading $sta_report_file_name"
if {[catch {set fd [open $tsp_report_file_name r]} err_tsp]} {
   #append buf "\n"
   continue
}
while {[eof $fd] != 1} {
  gets $fd line
  set wns [string first "| Design Timing Summary" $line]
  if {$wns != -1} {
        gets $fd line
        gets $fd line
        gets $fd line
        gets $fd line
        gets $fd line
        gets $fd line
        puts $line
        scan $line "%f" WNS_Place
        puts $WNS_Place
        set Fmax_place [expr 1000/($case_period-$WNS_Place)]
        append buf "$WNS_Place,$Fmax_place"
  }
 }
close $fd
####################end tsp report##########################

####################tsr report##############################

#puts "Reading $sta_report_file_name"

if {[catch {set fd [open $tsr_report_file_name r]} err_msg]} {
   #append buf "\n"
   continue
}
while {[eof $fd] != 1} {
  gets $fd line
  set real_wns [string first "| Design Timing Summary" $line]
  if {$real_wns != -1} {
        gets $fd line
        gets $fd line
        gets $fd line
        gets $fd line
        gets $fd line
        gets $fd line
        puts $line
        scan $line "%f" Real_WNS
        puts $Real_WNS
        set real_fmax [expr 1000/($case_period-$Real_WNS)]
        append buf ",$Real_WNS,$real_fmax"
  }
 }
close $fd
####################end tsr report##########################

####################fit report##############################
#append buf $report_file_name
#puts "Reading $fit_report_file_name"
set fd [open $fit_report_file_name r]
while {[eof $fd] != 1} {
  gets $fd line
  #puts $line
  set lut_flag [string first "| CLB LUTs           | " $line]
  set reg_flag [string first "| CLB Registers              | " $line]
  set ram_flag [string first "RAMB18       |" $line]
  set slice_flag [string first "| CLB                        | " $line]
  if {$lut_flag != -1} {
        puts $line
        set lut_buf1 [string map {" " ""} $line]
        set lut_buf2 [string map {"|" ","} $lut_buf1]
        scan $lut_buf2 ",CLBLUTs,%d,%d,%d,%f," LUT LUT_Fixed LUT_Available LUT_Util
        puts $LUT,$LUT_Fixed,$LUT_Available,$LUT_Util
  }
  if {$reg_flag != -1} {
        puts $line            
        set reg_buf1 [string map {" " ""} $line]
        set reg_buf2 [string map {"|" ","} $reg_buf1]
        scan $reg_buf2 ",CLBRegisters,%d,%d,%d,%f," REG REG_Fixed REG_Available REG_Util
        puts $REG,$REG_Fixed,$REG_Available,$REG_Util
  }
  if {$ram_flag != -1} {
        puts $line            
        set ram_buf1 [string map {" " ""} $line]
        set ram_buf2 [string map {"|" ","} $ram_buf1]
        scan $ram_buf2 ",RAMB18,%d,%d,%d,%f," RAM RAM_Fixed RAM_Available RAM_Util
        puts $RAM,$RAM_Fixed,$RAM_Available,$RAM_Util
  } 
  if {$slice_flag != -1} {
        puts $line            
        set clb_buf1 [string map {" " ""} $line]
        set clb_buf2 [string map {"|" ","} $clb_buf1]
        scan $clb_buf2 ",CLB,%d,%d,%d,%f," CLB CLB_Fixed CLB_Available CLB_Util
        puts $CLB,$CLB_Fixed,$CLB_Available,$CLB_Util
  }
 }
append buf ",$LUT,$LUT_Available,$LUT_Util,$REG,$REG_Available,$REG_Util,$RAM,$RAM_Available,$RAM_Util,$CLB,$CLB_Available,$CLB_Util"
close $fd
####################end fit report##########################

####################synth report##########################
cd $batch_folder/$proj_name/$proj_name.runs/synth_1
if {[catch {set wb [open "runme.log" r]} err_wb]} {
   continue
}
while {[eof $wb] != 1} {
        gets $wb line
  set syn_flag [string first "Synthesis finished with" $line]
  if {$syn_flag != -1} {
        gets $wb line
        gets $wb line
        puts $line
        set syn_buf1 [string map {"Synthesis Optimization Complete : Time (s): cpu = " "" "; elapsed = " "" ". Memory (MB): peak = " "" "; gain = " ""} $line]
        set syn_buf2 [string map {" " "," ":" ","} $syn_buf1]
        scan $syn_buf2 "%d,%d,%d,%d,%d,%d,%f,%f," h01 m01 s01 h02 m02 s02 syn_Memory ex0
        puts $h01,$m01,$s01,$h02,$m02,$s02,$syn_Memory,$ex0
}
}
 append buf ",$h01\:$m01\:$s01,$syn_Memory"
close $wb
####################end synth report##########################

####################PAR report##############################
cd $batch_folder/$proj_name/$proj_name.runs/impl_1
if {[catch {set fd [open $time_report_file_name r]} err_msg]} {
   append buf "\n"
   continue
}
while {[eof $fd] != 1} {
  gets $fd line
  set Place_flag [string first "place_design completed successfully" $line]
  set Route_flag [string first "route_design completed successfully" $line]
  if {$Place_flag != -1} {
        gets $fd line
        puts $line    
        set Place_buf1 [string map {"place_design: Time (s): cpu = " "" "; elapsed = " "" ". Memory (MB): peak = " "" "; gain = " ""} $line]
        set Place_buf2 [string map {" " "," ":" ","} $Place_buf1]
        scan $Place_buf2 "%d,%d,%d,%d,%d,%d,%f,%f," h11 m11 s11 h12 m12 s12 Place_Memory ex1
        puts $h11,$m11,$s11,$h12,$m12,$s12,$Place_Memory,$ex1
        set e1 [expr  (3600*$h12+60*$m12+$s12)]
        set c1 [expr  (3600*$h11+60*$m11+$s11)]
        set fe1 [format "%f" $e1]
        set fc1 [format "%f" $c1]
#set elaspedPvscpu [expr  100*(3600*$h12+60*$m12+$s12-3600*$h11-60*$m11-$s11)/(3600*$h11+60*$m11+$s11)]
set elaspedPvscpu [expr  100*($fe1-$fc1)/($fc1)]
set ePvsc [format "%0.3f" $elaspedPvscpu]
puts $ePvsc
  }
  if {$Route_flag != -1} {
        gets $fd line
        puts $line              
        set Route_buf1 [string map {"route_design: Time (s): cpu = " "" "; elapsed = " "" ". Memory (MB): peak = " "" "; gain = " ""} $line]
        set Route_buf2 [string map {" " "," ":" ","} $Route_buf1]
        scan $Route_buf2 "%d,%d,%d,%d,%d,%d,%f,%f," h21 m21 s21 h22 m22 s22 Route_Memory ex2
        puts $h21,$m21,$s21,$h22,$m22,$s22,$Route_Memory,$ex2
        set e2 [expr  (3600*$h22+60*$m22+$s22)]
        set c2 [expr  (3600*$h21+60*$m21+$s21)]
        set fe2 [format "%f" $e2]
        set fc2 [format "%f" $c2]
        set elaspedRvscpu [expr  100*($fe2-$fc2)/($fc2)]
        set eRvsc [format "%0.3f" $elaspedPvscpu]
        #set elaspedRvscpu [expr 100*(3600*$h22+60*$m22+$s22-3600*$h21-60*$m21-$s21)/(3600*$h21+60*$m21+$s21)]
        puts $eRvsc
        }
}
append buf ",$h11\:$m11\:$s11,$h12\:$m12\:$s12,$ePvsc,$Place_Memory,$h21\:$m21\:$s21,$h22\:$m22\:$s22,$eRvsc,$Route_Memory"
close $fd
####################end PAR report##########################
 #puts "\n"
append buf "\n"
}
}

cd $batch_folder
set spread_sheet_file [open "$device_prefix\_$top_module\_report.csv" w]
puts $spread_sheet_file $buf
close $spread_sheet_file   
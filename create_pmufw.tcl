proc create_pmufw {xsa} {
 
 hsi::open_hw_design $xsa
 common::report_property [hsi::current_hw_design]
 
 set pmufw_design [hsi::create_sw_design pmu_1 -proc psu_pmu_0 -app zynqmp_pmufw]
 
 hsi::add_library libmetal
 hsi::generate_app -dir pmu_fw -compile
 
 return "pmu_fw/pmufw.elf"
}


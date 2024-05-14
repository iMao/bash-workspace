proc create_fsbl {xsa} {
 
 hsi::open_hw_design $xsa
 common::report_property [hsi::current_hw_design]
 
 set fsbl_design [hsi::create_sw_design fsbl_1 -proc psu_cortexa53_0 -app zynqmp_fsbl]
 
 common::set_property APP_COMPILER "aarch64-none-elf-gcc" $fsbl_design
 common::set_property -name APP_COMPILER_FLAGS -value "-DRSA_SUPPORT -DFSBL_DEBUG_INFO -DXPS_BOARD_ZCU102" -objects $fsbl_design
 
 hsi::add_library libmetal
 hsi::generate_app -dir zynqmp_fsbl  -compile
        
 return "zynqmp_fsbl/fsbl.elf"
}



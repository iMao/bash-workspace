proc create_fsbl {xsa} {
 
 hsi::open_hw_design $xsa
 common::report_property [hsi::current_hw_design]
 

 set fsbl_design [hsi::create_sw_design fsbl_1  -os standalone -proc ps7_cortexa9_0 -app zynq_fsbl]

  #-DXPS_BOARD_ZC706
  #-DFSBL_DEBUG_INFO 
 common::set_property APP_COMPILER "arm-none-eabi-gcc" $fsbl_design
 common::set_property -name APP_COMPILER_FLAGS -value "-DRSA_SUPPORT " -objects $fsbl_design
 
  #hsi::add_library libmetal
 hsi::generate_app -dir zynq_fsbl  -compile
 
 return "zynq_fsbl/fsbl.elf"
}



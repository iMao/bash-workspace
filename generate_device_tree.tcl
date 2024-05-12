proc generate_device_tree {xsa dir_device_tree_xlnx} {
	hsi::open_hw_design $xsa

	set path $dir_device_tree_xlnx
    file mkdir $path
	file attributes $path -owner root

	hsi::set_repo_path $path
	set proc 0
	foreach procs [hsi::get_cells -hier -filter {IP_TYPE==PROCESSOR}] {
		if {[regexp {cortex} $procs]} {
			set proc $procs
			break
		}
	}
	if {$proc != 0} {
		puts "Targeting $proc"
		hsi::create_sw_design device-tree -os device_tree -proc $proc
		hsi::generate_target -dir rru_dts
	} else {
		puts "Error: No processor found in XSA file"
	}
	hsi::close_hw_design [hsi::current_hw_design]
}

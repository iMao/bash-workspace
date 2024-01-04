#!/bin/bash

#clone, config & build of linux kernel from Xilinx

nthreads=12

line="--------------------------------------------------------------------"

branch_version="xilinx-v2021.2"
kernel_branch_name="refs/tags/${branch_version}"
local_branch_name=${branch_version}

defconfig_fname=xilinx_zynqmp_defconfig

device_tree_name="zynqmp-zcu102-rev1.1"
device_tree_name_dtb="${device_tree_name}.dtb"

kernel_image_fname=Image

cd ../repositories/linux-xlnx
repositories_dirname=$(pwd)

cd ./arch/arm64/boot
kernel_image_directory=$(pwd)

cd ../../../../
mkdir output
cd ./output

output_dirname=$(pwd)

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export KERNEL_DTB=$device_tree_name_dtb
export DEVICE_TREE=$device_tree_name


function PrintParams {
    echo ${line}
    echo "Number of CPU threads: ${nthreads}"
    echo "git repository branch version: ${branch_version}"
    echo "defconfig file: ${defconfig_fname}"
    echo "Device tree dts: ${device_tree_name}"
    echo "Device tree dtb: ${device_tree_name_dtb}"
    echo "Linux kernel image name: ${kernel_image_fname}"
    echo "Linux kernel image directory: ${kernel_image_directory}"
    echo "Linux kernel repository: ${repositories_dirname}"
    echo "Output directory: ${output_dirname}"
    echo ${line}
    echo ${ARCH}
    echo ${CROSS_COMPILE}
    echo ${KERNEL_DTB}
    echo ${DEVICE_TREE}
    echo ${line}
}




PrintParams


echo "clone, config & build of linux kernel from Xilinx branch name: ${kernel_branch_name}"

if [ ! -d ${repositories_dirname} ]; then
    echo "Please clone git repository first!"
    exit
else
    echo "Linux kernel's source code here: ${repositories_dirname}"
fi


if [ ! -d ${output_dirname} ]; then
    echo "Couldn't create output directory"    
fi

cd ${repositories_dirname}

current_branch_name=$(git branch --show-current)

if [[ "${current_branch_name}" != "${local_branch_name}" ]]; then
    git checkout ${kernel_branch_name} -b ${local_branch_name}
fi

echo "Current branch: ${current_branch_name}"


make distclean
exit

make $defconfig_fname
exit

#make -j${nthreads}







if [ -f $kernel_image_directory/$kernel_image_fname ]; then
cp $kernel_image_directory/$kernel_image_fname ../../$output_dirname
echo "Linux kernel has been built successfully"
else
echo "Linux kernel has been built failed"
fi




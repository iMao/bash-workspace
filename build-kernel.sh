#!/bin/bash

#clone, config & build of linux kernel from Xilinx

nthreads=8
kernel_branch_name="refs/tags/xilinx-v2021.1"
local_branch_name="xilinx-v2021.1"

defconfig_fname=xilinx_zynqmp_defconfig

device_tree_name="zynqmp-zcu102"
device_tree_name_dtb="${device_tree_name}.dtb"

kernel_image_fname=Image
kernel_image_directory=./arch/arm64/boot

repositories_dirname=repositories
output_dirname=output

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export KERNEL_DTB=$device_tree_name_dtb
export DEVICE_TREE=$device_tree_name

echo "clone, config & build of linux kernel from Xilinx branch name: $kernel_branch_name"

if [ ! -d $repositories_dirname ]; then
mkdir $repositories_dirname
else
rm -Rf $repositories_dirname/*
fi

cd $repositories_dirname

if [ ! -d ./$output_dirname ]; then
mkdir $output_dirname
else
rm -Rf $output_dirname
fi

git clone  https://github.com/Xilinx/linux-xlnx.git
cd ./linux-xlnx
git checkout  $kernel_branch_name -b $local_branch_name

make distclean
make $defconfig_fname
make -j$nthreads

if [ -f $kernel_image_directory/$kernel_image_fname ]; then
cp $kernel_image_directory/$kernel_image_fname ../../$output_dirname
echo "Linux kernel has been built successfully"
else
echo "Linux kernel has been built failed"
fi




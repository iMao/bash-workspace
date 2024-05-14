#!/bin/bash

# build script for u-boot bootloader

line="-----------------------------------------------------------------------------------"

function PrintParams {
    echo ${line}
    echo "Number of CPU threads: ${nthreads}"
    echo "git repository branch version: ${branch_version}"
    echo "defconfig file: ${defconfig_fname}"
    echo "Device tree dts: ${device_tree_name}"
    echo "Device tree dtb: ${device_tree_name_dtb}"
    echo "u-boot image name: ${uboot_image_name}"
    echo "u-boot image directory: ${uboot_image_directory}"
    echo "u-boot repository: ${repositories_dirname}"
    echo "Output directory: ${output_dirname}"
    echo ${line}
    echo "${ARCH}"
    echo "${CROSS_COMPILE}"
    echo "${DEVICE_TREE}"
    echo "${line}"
}

nthreads=1

# first cmd param is number of threads for build
if [ -z "$1" ]; then
    nthreads=$1 
fi    

branch_version="xilinx-v2021.2"
uboot_branch_name="refs/tags/${branch_version}"
local_branch_name=${branch_version}

defconfig_fname=xilinx_zynqmp_virt_defconfig

device_tree_name="zynqmp-zcu102-rev1.1"
device_tree_name_dtb="${device_tree_name}.dtb"

uboot_image_name=u-boot

cd ../repositories/u-boot-xlnx || exit
repositories_dirname=$(pwd)
uboot_image_directory=${repositories_dirname}

cd ../

if [ ! -d  "$(pwd)/output" ]; then
    mkdir output
fi

cd ./output || exit

output_dirname=$(pwd)

PrintParams

echo "Config & build of u-boot loader from Xilinx branch name: ${uboot_branch_name}"

if [ ! -d "${repositories_dirname}" ]; then
    echo "Please clone git repository first!"
    exit
else
    echo "u-boot loader's source code here: ${repositories_dirname}"
fi

if [ ! -d "${output_dirname}" ]; then
    echo "Couldn't create output directory"
    exit    
fi

cd "${repositories_dirname}" || exit

# get short name of git branch
current_branch_name=$(git branch --show-current)

if [[ "${current_branch_name}" != "${local_branch_name}" ]]; then
    git checkout ${uboot_branch_name} -b ${local_branch_name}
fi

echo "Current branch: ${current_branch_name}"

export ARCH=aarch64
export CROSS_COMPILE=aarch64-linux-gnu-
export DEVICE_TREE=$device_tree_name

make distclean
make ${defconfig_fname}
make -j"${nthreads}"

echo ${line}
if [ -f "${uboot_image_directory}/${uboot_image_name}" ]; then
    cp --update "${uboot_image_directory}/${uboot_image_name}" "${output_dirname}"
    cd "${output_dirname}" || exit
    mv ${uboot_image_name} "${uboot_image_name}.elf" 
    echo "u-boot loader has been built successfully"
else
    echo "u-boot loader has been built failed"
fi

#!/bin/bash

#config & build of linux rootfs 

line="-----------------------------------------------------------------------------------"

function PrintParams {
    echo ${line}
    echo "Number of CPU threads: ${nthreads}"
    echo "git repository branch version: ${branch_version}"
    echo "defconfig file: ${defconfig_fname}"
    echo "Linux rootfs name: ${rootfs_name}"
    echo "Buildroot directory: ${buildroot_directory}"
    echo "Buildroot repository: ${repositories_dirname}"
    echo "Output directory: ${output_dirname}"
}

function PrintCompilerParams {
    echo ${line}
    echo "${ARCH}"
    echo "${CROSS_COMPILE}"
}

nthreads=1

# first cmd param is number of threads for build
if [ -z "$1" ]; then
    nthreads=$1 
fi   

branch_version="2021.02"
buildroot_branch_name=refs/tags/${branch_version}
local_branch_name=${branch_version}

defconfig_fname=zcu102_defconfig
rootfs_name=rootfs.cpio
uboot_rootfs_name=uramdisk.image.gz

cd ../repositories/buildroot || exit
repositories_dirname=$(pwd)

buildroot_directory="${repositories_dirname}/output/images"

cd ../../../../
if [ ! -d  "$(pwd)/output" ]; then
    mkdir output
fi

cd ./output || exit

output_dirname=$(pwd)

PrintParams

cd "${repositories_dirname}" || exit

# get short name of git branch
current_branch_name=$(git branch --show-current)

if [[ "${current_branch_name}" != "${local_branch_name}" ]]; then
    git checkout ${buildroot_branch_name} -b ${local_branch_name}
fi

echo "Current branch: ${current_branch_name}"

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

PrintCompilerParams

make distclean
make ${defconfig_fname}
make -j"${nthreads}"

cd "${buildroot_directory}" || exit
mkimage -A arm -T ramdisk -C gzip -d ${rootfs_name} ${uboot_rootfs_name}

echo ${line}
if [ -f "${buildroot_directory}/${rootfs_name}" ]; then
    cp --update "${buildroot_directory}/${uboot_rootfs_name}" "${output_dirname}"
    echo "Linux rootfs has been built successfully"
else
    echo "Linux rootfs has been built failed"
fi


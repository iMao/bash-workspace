#!/bin/bash

echo "Creation of device tree description of hardware"

if [ -z "$1" ]; then
    echo "You need to set hardware description file xsa as parameter for this bash script"
    exit
fi

if [ -z "$2" ]; then
    echo "You need to set directory of repository device-tree-xlnx for this bash script"
    exit
fi

echo "You have set of hardware description file xsa: $1"
xsa=$1

echo "You have set of directory of repository: $2"
repo_directory=$2

if [ ! -f "$xsa" ]; then
    echo "hardware description file $xsa does not exist"
    exit
fi

if [ ! -d "$repo_directory" ]; then
    echo "$repo_directory does not exist"
    exit
fi

echo "generate_device_tree $xsa $repo_directory" | xsct -eval 'source generate_device_tree.tcl' -interactive


if [ ! -d ./rru_dts ]; then
    echo "directory rru_dts is absent"
    exit
fi

cd ./rru_dts || exit

echo "Compilation of device tree"
gcc -E -nostdinc -undef -D__DTS__ -x assembler-with-cpp -o system.dts system-top.dts

echo "Building of device tree"
dtc -I dts -O dtb -o system.dtb  system.dts


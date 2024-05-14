#!/bin/bash

echo "Creation of platform management unit firmware pmufw.elf"

if [ -z "$1" ]; then
    echo "You need to set hardware description file xsa as parameter for this bash script"
    exit
fi

echo "You have set of hardware description file xsa: $1"
xsa=$1

if [ ! -f "$xsa" ]; then
    echo "$xsa hardware description file is absent"
    exit
fi

echo "create_pmufw $xsa" | xsct -eval 'source create_pmufw.tcl' -interactive

cd ./pmu_fw && mv executable.elf pmufw.elf && cd ../

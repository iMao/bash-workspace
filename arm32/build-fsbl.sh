#!/bin/bash

if [ -z "$1" ]; then
    echo "You need to set hardware description file xsa as parameter for this bash script"
    exit
fi

if [ "$1" == "clean" ]; then
    
    if [ -d ".Xil" ]; then
    rm -Rf ./.Xil 
    fi

    if [ -d "zynq_fsbl" ]; then
    rm -Rf ./zynq_fsbl
    fi
    
    if [ -f "fsbl.elf" ]; then
    rm fsbl.elf
    fi

    if [ -f "ps7_init_gpl.c" ]; then   
    rm ./ps7_init_gpl.c 
    fi 
    
    if [ -f "ps7_init_gpl.h" ]; then
    rm ./ps7_init_gpl.h
    fi

    if [ -f "ps7_init.h" ]; then 
    rm ./ps7_init.h
    fi
    
    if [ -f "ps7_init.c" ]; then
    rm ./ps7_init.c
    fi

    if [ -f "ps7_init.html" ]; then
    rm ./ps7_init.html
    fi

    if [ -f "ps7_init.tcl" ]; then
    rm ./ps7_init.tcl
    fi

    echo "All old files & folders were cleaned OK"
    exit
fi


echo "Creation of ARM32 first stage bootloader fsbl.elf"
echo "You have set of hardware description file xsa: $1"
xsa=$1

if [ ! -f "$xsa" ]; then
    echo "$xsa hardware description file is absent"
    exit
fi

echo "create_fsbl $xsa" | xsct -eval 'source create_fsbl.tcl' -interactive

cd ./zynq_fsbl && mv executable.elf fsbl.elf && cp fsbl.elf ../







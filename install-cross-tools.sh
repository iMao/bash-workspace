#!/bin/bash

#instalation of tools for cross compilation for ARM64 


apt update
apt install gcc-aarch64-linux-gnu -y
apt install binutils-aarch64-linux-gnu
apt install gcc-9-multilib -y
apt install gcc-multilib -y
apt install libc6-arm64-cross
apt install libc6-dev-arm64-cross -y
apt install g++-aarch64-linux-gnu -y
apt install bison -y
apt install flex -y
apt install libssl-dev
apt install bc

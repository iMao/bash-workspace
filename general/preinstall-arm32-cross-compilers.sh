#!/bin/sh

# arm32 cross-compilers tools

apt update
apt install -y gcc-arm-linux-gnueabihf
apt install -y g++-arm-linux-gnueabihf
apt install -y libc6-armel-cross
apt install -y libc6-dev-armel-cross
apt install -y binutils-arm-linux-gnueabi
apt install -y libncurses5-dev
apt install -y build-essential
apt install -y bison
apt install -y flex
apt install -y libssl-dev
apt install -y bc
apt install -y libgnutls28-dev
apt install -y u-boot-tools


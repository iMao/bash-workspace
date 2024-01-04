#!/bin/bash
# script for checking of existing of directory

echo -n "Input directory name for check:"
read dirname

msg_exist="Yes, directory: $dirname exist!"
msg_absent="No, directory: $dirname absent!"

if [ -d ${dirname} ]; then
  echo ${msg_exist}
else
  echo ${msg_absent}
fi


#!/bin/bash

if [ $# -eq 0 ]
then
   echo "please provide a file as an argument"
   exit 1
fi

for file in ${@}
do

    echo "---------------------------------"
    echo "Testing $file"

    python -c 'import yaml,sys; yaml.safe_load(sys.stdin)' < $file 2>&1 | sed -n -e '/ScannerError/,$p'

done


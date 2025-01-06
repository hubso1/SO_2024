#!/bin/bash

disks=$(lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,UUID,PATH)
time=$(date +"%Y%m%d-%H%M%S")
filename="Report_${time}.txt"
{
    echo "Informacje o dostępnych dyskach i partycjach:"
    echo "$disks"
    echo
    echo "Użycie miejsca na partycjach zamontowanych:"
    echo
    df -h | awk 'NR==1 || /^\/dev/'
    echo
} > "$filename"
echo "Plik o nazwie $filename został zapisany w $(pwd)."

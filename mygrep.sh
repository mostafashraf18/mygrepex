#!/bin/bash

show_lines=false
invert=false
word=0
file=0

if [ $1 == "--help" ]; then
    echo "The useage: $0 <pattern> <file-name>"
    exit 0
fi

if [ $# -lt 2 ]; then # < 2
    echo "Error: it must be 2 argumments check --help"
    exit 1
fi

while getopts ":nv" opt; do
	case "$opt" in
		 n) show_lines=true ;;
        	 v) invert=true ;;
        	 *) echo "Invalid option: -$OPTARG" >&2
           exit 1 ;;
    esac
done

shift $((OPTIND-1)) # get the actual word & file

word=$1
file=$2

if [ -z "$word" ]; then
    echo "Missing search word!"
    exit 1
fi

if [ ! -f "$file" ]; then
   echo "does not exist."
   exit 1
fi

line_number=0

# Read file line-by-line
while IFS= read -r line; do
    ((line_number++))

    if echo "$line" | grep -i -q "$word"; then
        match=true
    else
        match=false
    fi

    if [ "$invert" == true ]; then
        if [ "$match" == true ]; then
            match=false
        else
            match=true
        fi
    fi

    if [ "$match" == true ]; then
        if [ "$show_lines" == true ]; then
            echo "${line_number}:$line"
        else
            echo "$line"
        fi
    fi
done < "$file"

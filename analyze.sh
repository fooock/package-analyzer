#!/bin/bash

dir_to_analyze=$1

echo " [+] Analyzing package $dir_to_analyze"

## Iterate over all interesting files
for file in $(find $dir_to_analyze -name '*c' -or -name '*.cpp')
do
	## Anlize here with the required regexp
done

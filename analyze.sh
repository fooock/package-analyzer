#!/bin/bash

dir_to_analyze=$1
reg_exp_file=$2

echo " [+] Analyzing package $dir_to_analyze"

files_found=0
matched_lines=0
analyzed_lines=0
## Iterate over all interesting files
for file in $(find $dir_to_analyze -name '*c' -or -name '*.cpp' -or -name '*.h')
do
	## Discard directories
	if [[ -d $file ]]; then
		continue
	fi
	## Analize here line by line with the required regexp
	while read -r line; do
		## Check if the line contain any reg exp from the reg_exp text file
		while read -r regexp; do
			if [[ $line =~ $regexp ]]; then
				let matched_lines++
			fi
		done < $reg_exp_file

		let analyzed_lines++
	done < $file	

	## Show results
	printf "  [+] Files found: $files_found - Lines analyzed: $analyzed_lines - Matched lines: $matched_lines\r"
	let files_found++
done

echo

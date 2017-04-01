#!/bin/bash

dir_to_analyze=$1
reg_exp_file=$2

echo " [+] Analyzing package $dir_to_analyze"

## Extract the basename of the full path. This is used to create a directory
## where the report is stored
PACKAGE_BASE_NAME=$(basename $dir_to_analyze)

REPORT_DIRECTORY=$dir_to_analyze/../../report/$PACKAGE_BASE_NAME
REPORT_FILE=$REPORT_DIRECTORY/report.txt

## Delete the report directory if it exists
if [[ -d $REPORT_DIRECTORY ]]; then
  rm -rf $REPORT_DIRECTORY
fi
mkdir -p $REPORT_DIRECTORY
touch $REPORT_FILE

## This function write a match to the report files. Note that each match
## is represented by one line. The format is:
## <file> <line> <regexp>
## The name of the file is relative to the package is being analyzed
function write_match_to_report {
  file_name=$(realpath --relative-to=$dir_to_analyze $1)
  echo "$file_name $2 $3" >> $REPORT_FILE
}

files_found=0
matched_lines=0
analyzed_lines=0
## Iterate over all interesting files
for file in $(find $dir_to_analyze -name '*.c' -or -name '*.cpp' -or -name '*.h' -or -name '*.tpp' -or -name '*.hpp')
do
	## Discard directories
	if [[ -d $file ]]; then
		continue
	fi
  current_line=0
	## Analize here line by line with the required regexp
	while read -r line; do
    current_line=$(($current_line+1))
		## Check if the line contain any reg exp from the reg_exp text file
		while read -r regexp; do
			if [[ $line =~ $regexp ]]; then
				let matched_lines++
        ## Filling report ;-)
        write_match_to_report $file $current_line $regexp
			fi
		done < $reg_exp_file

		let analyzed_lines++
	done < $file
  let files_found++
	## Show results
	echo -ne "  [+] Files found: $files_found - Lines analyzed: $analyzed_lines - Matched lines: $matched_lines\r"
done

## When all files of the package are analyzed, if we have more than 0 matched files,
## send the result to make an advanced analysis
if [[ $matched_lines -gt 0 ]]; then
  echo
	echo "  [+] Sending results to make an advanced analysis..."
else
  echo
  echo "  [+] No matches found!"
fi

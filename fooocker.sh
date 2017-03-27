#!/bin/bash

## This is the file where all the system packages are written
PACKAGES_FILE_NAME="packages-list"

## File to store the total packages to analyze
TOTAL_PACKAGES_FILE_NAME="total"

## Main working directory. All reports are written to this directory.
## Note that this directory is relative to the current user directory
WORK_DIRECTORY="fooocker"

## Name of the directory where the packages are downloaded
DEST_PACKAGES_NAME="downloaded-packages"

function help {
	echo	
	echo -e "Usage: ./fooocker.sh [-n number] [-s size]"
	echo -e "\t-n [number] - is the number of packages to analyze"
	echo -e "\t-s [size] - is the max size of the package to analyze in bytes"
}

## Check the command line to get the current options if exists. The current
## supported option is -n, that is, the number of packages to analyze
while getopts ":n:s:h" opt; do
	case $opt in
		s)
			## Check if the option is a number. If is not a number the program
			## exit with status 1 and shows an error message in the console
			number=${OPTARG}
			if ! [[ $number =~ ^[0-9]+$ ]]; then
				echo "Error: $number is not a number!"
				help
				exit 1
			fi
			PREFERRED_PKG_SIZE=${OPTARG}
			;;
		h)
			help
			exit 0
			;;
		n)
			## Check if the option is a number. If is not a number the program
			## exit with status 1 and shows an error message in the console
			number=${OPTARG}
			if ! [[ $number =~ ^[0-9]+$ ]]; then
				echo "Error: $number is not a number!"
				help
				exit 1
			fi
			NUMBER_PKG_TO_ANALYZE=${OPTARG}
			;;
		\?)
			echo "Invalid option: -$OPTARG"
			help
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument"
			help
			exit 1
			;;
	esac
done

echo "-------------------------------------"
echo "  INITIALIZING..."
echo "-------------------------------------"
echo "[+] Preparing environment"

## Check if the WORK_DIRECTORY exists. If exists then we delete all content
## to create a fresh direcotry where the new data will be stored
if [ -d $WORK_DIRECTORY ]; then
	rm -rf $WORK_DIRECTORY
fi

mkdir $WORK_DIRECTORY
echo "[+] Setting working directory at $(pwd)/$WORK_DIRECTORY)"

cd $WORK_DIRECTORY

## Retrieve new list of system packages
echo "[+] Updating packages..."
sudo apt-get update > /dev/null 2>&1
echo "[+] Updated!"

echo "[+] Getting packages..."

## Create the list of packages to analyze. One per line
apt list 2> /dev/null | cut -d/ -f1 > $PACKAGES_FILE_NAME
## We need to remove the first line of the file PACKAGES_FILE_NAME because
## it contains the string 'Listing...'
tail -n +2 $PACKAGES_FILE_NAME > $PACKAGES_FILE_NAME.tmp && mv $PACKAGES_FILE_NAME.tmp $PACKAGES_FILE_NAME

## Create the file to store the total number of packages to analyze
wc -l $PACKAGES_FILE_NAME > $TOTAL_PACKAGES_FILE_NAME
total_packages=$(cut -d' ' -f1 $TOTAL_PACKAGES_FILE_NAME)

filtered_packages=0
passed_filter=0
## This function uses apt-cache show to get the package size. Note that
## the package size is in bytes
function filter_package_by_size {
	name=$1
	size=$(apt-cache show $name | grep ^Size | cut -d':' -f2 | tr -d '[:space:]')
	if [[ $size -lt $PREFERRED_PKG_SIZE ]]; then
		let passed_filter++
	else
		grep -v $name $PACKAGES_FILE_NAME > $PACKAGES_FILE_NAME.tmp 
		mv $PACKAGES_FILE_NAME.tmp $PACKAGES_FILE_NAME
	fi
	let filtered_packages++
	printf "[-] Filtered($passed_filter) - Analyzed $filtered_packages of $total_packages packages\r"
}

## Create the list of packages depending on the package size. If this
## option is 0 then all packages are selected
if [[ $PREFERRED_PKG_SIZE -gt 0 ]]; then
	echo "[+] Filtering package list by size"
	while read -r package; do
		filter_package_by_size $package
	done < $PACKAGES_FILE_NAME
fi

echo "[+] Found $total_packages packages to analyze"

function download_banner {
	echo "-------------------------------------"
	echo "  DOWNLOADING..."
	echo "-------------------------------------"

	mkdir $DEST_PACKAGES_NAME
	## Change the directory now. For each package downloaded we create a
	## folder with the name of the current package
	cd $DEST_PACKAGES_NAME
}

## Execute depending on the number of packages to scan. If the number is
## equals to 0 then all packages are analyzed
if [[ $NUMBER_PKG_TO_ANALYZE -eq 0 ]]; then
	echo "[+] Prepared to analyze ALL packages"
	download_banner
	while read -r line; do
		source ../../download_source.sh $line
	done < ../$PACKAGES_FILE_NAME
else
	echo "[+] Prepared to analyze $NUMBER_PKG_TO_ANALYZE packages"
	download_banner
	init_package=0
	while [[ $init_package -lt $NUMBER_PKG_TO_ANALYZE ]] && read -r line; do
		source ../../download_source.sh $line
		let init_package++
	done < ../$PACKAGES_FILE_NAME
fi

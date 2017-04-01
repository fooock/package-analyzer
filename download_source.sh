#!/bin/bash

package_name=$1

function download_source {
  echo "[+] Downloading package $package_name"

  ## Create the directory with the same name of the package that will
  ## be downloaded and checkout in the new directory
  mkdir $package_name
  cd $package_name

  ## Download the package
  apt-get source $package_name > /dev/null 2>&1

	## get the name of the extracted package. It should be the unique directory
	extracted_dir=$(ls -l | grep ^d | awk '{print $NF}')
  if [[ -d $extracted_dir ]]; then
    ../../../analyze.sh $(pwd)/$extracted_dir ../../../reg_exp.txt
  else
    echo "[-] Package $extracted_dir not found!"
  fi

  ## Return to the previous directory
  cd ..
}

download_source $package_name

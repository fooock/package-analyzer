#!/bin/bash

package_name=$1

function download_source {
  echo "[+] Downloading package $package_name"

  ## Create the directory with the same name of the package that will
  ## be downloaded and checkout in the new directory
  mkdir $package_name
  cd $package_name

  ## Download the package
  apt-get source $package_name

  ## Return to the previous directory
  cd ..
}

download_source $package_name

#!/bin/bash
cd /path/to/packages
files=$(ls /deb/dir/*.deb)
for package in $files; do 
  reprepro includedeb wheezy $package
done

#!/bin/bash

if [ "$#" -ne "1" ] ; then
  echo "Usage $0 <infile.html>"
  exit 1
fi

cat "$1" |\
  sed 's/</\n</g' |\
  grep -b1 "strong class" |\
  grep -A1 gist.github.com |\
  sed '/.*gist.github.com.*/N;s/\n/ /' |\
  sed 's/.*href="\(.*\)">.*">\(.*\)/\1    \2/' |\
  grep -v -- -- > gist-items.txt


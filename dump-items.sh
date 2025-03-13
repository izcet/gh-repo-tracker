#!/bin/bash

cat Repositories.html |\
  sed 's/</\n</g' |\
  grep github.com |\
  grep mr-1 |\
  sed 's/.*href="//' |\
  sed 's/">/    /' > repo-items.txt



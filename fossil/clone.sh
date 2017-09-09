#!/bin/sh

mkdir fossil/$1 &&
cd fossil/$1 &&
fossil clone $2 $1.fossil &&
mkdir $1_fossil &&
cd $1_fossil &&
fossil open ../$1.fossil &&
git init ../$1_git &&
cd ../$1_git &&
fossil export --git \
       --export-marks ../fossil.marks \
       ../$1.fossil |
    git fast-import \
       --export-marks=../git.marks &&
git checkout trunk

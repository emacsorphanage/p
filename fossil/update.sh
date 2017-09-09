#!/bin/bash

cd fossil/$1/$1_fossil &&
fossil pull &&
cd ../$1_git &&
fossil export --git \
       --import-marks ../fossil.marks \
       --export-marks ../fossil.marks \
       ../$1.fossil |
    git fast-import \
       --import-marks=../git.marks \
       --export-marks=../git.marks

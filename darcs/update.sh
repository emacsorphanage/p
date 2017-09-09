#!/bin/sh

cd darcs/$1/$1_darcs &&
darcs pull &&
darcs convert export \
      --read-marks ../darcs.marks \
      --write-marks ../darcs.marks |
    (cd ../$1_git; git fast-import \
      --import-marks=../git.marks \
      --export-marks=../git.marks)

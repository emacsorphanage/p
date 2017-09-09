#!/bin/sh

mkdir darcs/$1 &&
cd darcs/$1 &&
darcs clone $2 $1_darcs &&
git init $1_git &&
cd $1_darcs &&
darcs convert export \
      --read-marks ../darcs.marks \
      --write-marks ../darcs.marks |
    (cd ../$1_git; git fast-import \
      --export-marks=../git.marks)

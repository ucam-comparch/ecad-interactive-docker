#!/bin/bash

COMMONDIR=$1
SUBMISSIONDIR=$2
OPTIONS=$3

rm -rf $SUBMISSIONDIR/test_env
mkdir -p $SUBMISSIONDIR/test_env/src
cd $SUBMISSIONDIR/test_env
cp ../src/*.[Ss] ./src/
if [ -z "$(ls -A ./src)" ]; then
   echo "No .s or .S files ./src dir!"
   exit 1
fi
cp -R $COMMONDIR/framework/. ./
if [ $OPTIONS = "random" ]; then
   python3 $COMMONDIR/generate-random-tester.py $SUBMISSIONDIR/test_env/src/main.c
fi
make all || exit 1


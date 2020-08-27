#!/bin/bash

SUBMISSIONDIR=$1
ARGS=$2

cd $SUBMISSIONDIR/test_env
spike --isa=rv32i $ARGS -m0x80000000:0x10000 build/*.elf


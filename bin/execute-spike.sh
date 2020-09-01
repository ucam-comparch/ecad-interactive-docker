#!/bin/bash

SUBMISSIONDIR=$1
ARGS=$2

cd $SUBMISSIONDIR/test_env

LOG=$(spike --isa=rv32i $ARGS -m0x80000000:0x10000 build/*.elf 2>&1 || true)
echo "$LOG"
retVal=`echo "$LOG" | grep -oP "(?<=tohost = )[0-9]*"`        # Spike outputs instruction trace and then "*** FAILED *** (tohost = N)" where N is the error code
if [ $retVal -ne 0 ]; then
  if [ $((retVal % 2)) -eq 0 ]; then                          # If even, failed on division, otherwise on modulo
    grep -oP "(?<=TEST$((retVal / 2))DIV: ).*" ./src/main.c   # Grep in the testing source code for the correct answers
  else                                                        # Which are put there when the file is generated
    grep -oP "(?<=TEST$((retVal / 2))MOD: ).*" ./src/main.c
  fi
  exit 1
fi
exit 0


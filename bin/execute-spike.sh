#!/bin/bash

SUBMISSIONDIR=$1
OPTIONS=$2

cd $SUBMISSIONDIR/test_env
if [ $OPTIONS = "log" ]
then
  LOG=$(spike --isa=rv32i -l -m0x80000000:0x10000 build/*.elf 2>&1)
else
  LOG=$(spike --isa=rv32i -m0x80000000:0x10000 build/*.elf 2>&1)
fi
echo "$LOG"

CODE=$(echo "$LOG" | grep -oP "(?<=tohost = )[0-9]*")
[ -z "$CODE" ] && exit 0

if [ $((CODE % 2)) -eq 0 ]                                 # If even, failed on division, otherwise on modulo
then
  grep -oP "(?<=TEST$((CODE / 2))DIV: ).*" ./src/main.c    # Grep in the testing source code for the correct answers
else                                                       # Which are put there when the file is generated
  grep -oP "(?<=TEST$((CODE / 2))MOD: ).*" ./src/main.c
fi
exit 1


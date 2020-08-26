#!/bin/bash

TEMP=$(mktemp)
"$@" |& tee $TEMP
cat $TEMP | md5sum

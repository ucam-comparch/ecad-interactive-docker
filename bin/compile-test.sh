#!/bin/bash

TASKDIR=$1

mkdir -p $TASKDIR/common
cp -R $TASKDIR/test/assembly/. $TASKDIR/common/


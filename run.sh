#!/bin/bash

source params

for test in tests/distributed/*.vdb ; do
  vdbench/vdbench -s \
    vdbench_path=$vdbench_path \
    host1=$host1 \
    host2=$host2 \
    anchor1=$anchor1 \
    anchor2=$anchor2 \
    -f $test \
    -o results/distributed/`basename $test .vdb`
done

for test in tests/non-distributed/*.vdb ; do
  vdbench/vdbench -s \
    vdbench_path=$vdbench_path \
    host1=$host1 \
    anchor1=$anchor1 \
    -f $test \
    -o results/non-distributed/`basename $test .vdb`
done

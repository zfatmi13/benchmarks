#!/bin/bash

export PRISM_JAVAMAXMEM=8g
benchmarks/qvbs/prism-auto benchmarks/qvbs/table1 -p prism/prism/bin/prism --args-list "-ex -bisim -new,-ex -bisim -robust" --log benchmarks/qvbs/table1/logs --log-subdir
benchmarks/qvbs/prism-log-extract benchmarks/qvbs/table1/logs --extension=log --groupby=log_dir --groupkey=benchmark --fields=min_states,time_bisim > benchmarks/qvbs/table1/results.csv

cd benchmarks/jpf/jpf_files
export JAVA_HOME=/opt/java/openjdk8
export PATH="${JAVA_HOME}/bin:${ORIG_PATH}"
./run1.sh
export JAVA_HOME=/opt/java/openjdk
export PATH="${JAVA_HOME}/bin:${ORIG_PATH}"
cd ../../..
benchmarks/qvbs/prism-log-extract benchmarks/jpf/set_isolation/logs --extension=log --groupby=log_dir --groupkey=exbenchmark --fields=min_states,time_bisim > benchmarks/jpf/set_isolation/results.csv

benchmarks/qvbs/merge-table benchmarks/qvbs/table1/results.csv benchmarks/jpf/set_isolation/results.csv table1.txt
cat table1.txt

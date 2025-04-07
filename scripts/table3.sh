#!/bin/bash

export PRISM_JAVAMAXMEM=8g
mkdir benchmarks/qvbs/table3/logs
mkdir benchmarks/qvbs/table3/logs/ex.bisim.new
mkdir benchmarks/qvbs/table3/logs/ex.bisim.robust
cp benchmarks/qvbs/table1/logs/ex.bisim.new/crowds* benchmarks/qvbs/table3/logs/ex.bisim.new/
cp benchmarks/qvbs/table1/logs/ex.bisim.robust/crowds* benchmarks/qvbs/table3/logs/ex.bisim.robust/
mkdir benchmarks/jpf/logs
mkdir benchmarks/jpf/logs/ex.bisim.new
mkdir benchmarks/jpf/logs/ex.bisim.robust
cp benchmarks/jpf/set_isolation/logs/ex.bisim.new/* benchmarks/jpf/logs/ex.bisim.new/
cp benchmarks/jpf/set_isolation/logs/ex.bisim.robust/* benchmarks/jpf/logs/ex.bisim.robust/

benchmarks/qvbs/prism-auto benchmarks/qvbs/table3 -p prism/prism/bin/prism --args-list "-ex -bisim -new,-ex -bisim -robust" --log -ex -bisim qvbs/table3/logs --log-subdir
benchmarks/qvbs/prism-log-extract benchmarks/qvbs/table3/logs --extension=log --groupby=log_dir --groupkey=benchmark --fields=min_states,time_bisim > benchmarks/qvbs/table3/results.csv

cd benchmarks/jpf/jpf_files
export JAVA_HOME=/opt/java/openjdk8
export PATH="${JAVA_HOME}/bin:${ORIG_PATH}"
./run3.sh
export JAVA_HOME=/opt/java/openjdk
export PATH="${JAVA_HOME}/bin:${ORIG_PATH}"
cd ../../..
benchmarks/qvbs/prism-log-extract benchmarks/jpf/logs --extension=log --groupby=log_dir --groupkey=exbenchmark --fields=min_states,time_bisim > benchmarks/jpf/results.csv

benchmarks/qvbs/summary-table benchmarks/qvbs/table3/results.csv benchmarks/jpf/results.csv table3.txt
cat table3.txt

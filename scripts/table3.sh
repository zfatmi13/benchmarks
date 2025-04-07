#!/bin/bash

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

benchmarks/qvbs/prism-auto benchmarks/qvbs/table3 -p prism/prism/bin/prism --args-list "-ex -bisim -new,-ex -bisim -robust" --log benchmarks/qvbs/table3/logs --log-subdir
benchmarks/qvbs/prism-log-extract benchmarks/qvbs/table3/logs --extension=log --groupby=log_dir --groupkey=benchmark --fields=min_states,time_bisim > benchmarks/qvbs/table3/results.csv

cd benchmarks/jpf/jpf_files
./run3.sh
cd ../../..
benchmarks/qvbs/prism-log-extract benchmarks/jpf/logs --extension=log --groupby=log_dir --groupkey=exbenchmark --fields=min_states,time_bisim > benchmarks/jpf/results.csv

benchmarks/qvbs/summary-table benchmarks/qvbs/table3/results.csv benchmarks/jpf/results.csv table3.txt
cat table3.txt

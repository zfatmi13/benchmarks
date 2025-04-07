#!/bin/bash

benchmarks/qvbs/prism-auto benchmarks/qvbs/table4 -p prism/prism/bin/prism --args-list "-ex -bisim -new" --log benchmarks/qvbs/table4/logs --log-subdir
benchmarks/qvbs/prism-log-extract benchmarks/qvbs/table4/logs --extension=log --groupby=log_dir --groupkey=benchmark --fields=min_states,time_bisim > benchmarks/qvbs/table4/results.csv

cd benchmarks/jpf/jpf_files
./run4.sh
cd ../../..
benchmarks/qvbs/prism-log-extract benchmarks/jpf/queens/logs --extension=log --groupby=log_dir --groupkey=exbenchmark --fields=min_states,time_bisim > benchmarks/jpf/queens/results.csv

benchmarks/qvbs/merge-table benchmarks/qvbs/table4/results.csv benchmarks/jpf/queens/results.csv table4.txt
cat table4.txt

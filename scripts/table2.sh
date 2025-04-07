#!/bin/bash

mkdir benchmarks/qvbs/table2/logs
mkdir benchmarks/qvbs/table2/logs/ex.bisim.robust
cp benchmarks/qvbs/table1/logs/ex.bisim.robust/crowds.pm.const.TotalRuns=5,CrowdSize=10.positive.pctl.ex.bisim.robust.log benchmarks/qvbs/table2/logs/ex.bisim.robust/

benchmarks/qvbs/prism-auto benchmarks/qvbs/table2 -p prism/prism/bin/prism --args-list "-ex -bisim -robust" --log benchmarks/qvbs/table2/logs --log-subdir
benchmarks/qvbs/prism-log-extract benchmarks/qvbs/table2/logs --extension=log --groupby=log_dir --groupkey=benchmark --fields=min_states,time_bisim > benchmarks/qvbs/table2/results.csv
benchmarks/qvbs/make-table benchmarks/qvbs/table2/results.csv table2.txt
cat table2.txt

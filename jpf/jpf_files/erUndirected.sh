#!/bin/bash

# set up base value
prob=0
size=5

# loop through size = 2, 3, ..., 10
# and prob = 0.02, 0.04, ..., 1.0
for (( j = 1; j <= 10; j++ )); do
	prob=$(echo "$prob + 0.1"|bc)

	jpf_file=`echo -e "target=RandomUndirectedGraphTest\n
	classpath=.\n
	target.args=${size},${prob}\n
	@using=jpf-label\n
	label.class=label.BooleanLocalVariable\n
	label.BooleanLocalVariable.variable = RandomGraph.createUndirectedGraph():isConnected\n
	@using=jpf-probabilistic\n
	listener=probabilistic.listener.StateSpaceText;label.StateLabelText"`
	cat > RandomGraphTest.jpf <<EOF
	${jpf_file}
EOF
	# run JPF
	/home/jpf/jpf-core/bin/jpf RandomGraphTest.jpf
	java JPFtoPRISM RandomGraphTest ../erdos-renyi_undirected/erdosRenyiModelU${prob}
	/home/benchmarks/qvbs/prism-auto ../erdos-renyi_undirected/ -p /home/prism/prism/bin/prism --args-list "-ex -bisim -new,-ex -bisim -robust" --log ../logs --log-subdir

	rm ../erdos-renyi_undirected/erdosRenyiModelU${prob}.tra
	rm ../erdos-renyi_undirected/erdosRenyiModelU${prob}.lab
	rm RandomGraphTest.jpf
	rm RandomGraphTest.tra
	rm RandomGraphTest.lab
done

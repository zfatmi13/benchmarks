#!/bin/bash

# set up base value
size=3
prob_base=0.1

# loop through size = 2, 3, ..., 5
# and prob = 0.1, 0.2, ..., 0.9
for (( j = 1; j < 10; j++ )); do
	prob=$(echo "$prob_base * $j"|bc)

	jpf_file=`echo -e "target=RandomDirectedGraphTest\n
	classpath=.\n
	target.args=${size},${prob}\n
	@using=jpf-label\n
	label.class=label.BooleanLocalVariable\n
	label.BooleanLocalVariable.variable = RandomGraph.createDirectedGraph():isConnected\n
	@using=jpf-probabilistic\n
	listener=probabilistic.listener.StateSpaceText;label.StateLabelText"`
	cat > RandomGraphTest.jpf <<EOF
	${jpf_file}
EOF
	# run JPF
	/home/jpf/jpf-core/bin/jpf RandomGraphTest.jpf
	java JPFtoPRISM RandomGraphTest ../erdos-renyi_directed/erdosRenyiModelD${prob}
	/home/benchmarks/qvbs/prism-auto ../erdos-renyi_directed/ -p /home/prism/prism/bin/prism --args-list "-ex -bisim -new,-ex -bisim -robust" --log ../logs --log-subdir

	rm ../erdos-renyi_directed/erdosRenyiModelD${prob}.tra
	rm ../erdos-renyi_directed/erdosRenyiModelD${prob}.lab
	rm RandomGraphTest.jpf
	rm RandomGraphTest.tra
	rm RandomGraphTest.lab
done
#!/bin/bash

# set up base value
size=3
prob_base=0.1

# loop through size = 2, 3, ..., 5
# and prob = 0.1, 0.2, ..., 0.9
for (( j = 1; j < 10; j++ )); do
	prob=$(echo "$prob_base * $j" | bc)

	jpf_file=`echo -e "target=RandomDirectedGraphTest\n
	classpath=.\n
	target.args=${size},${prob}\n
	@using=jpf-label\n
	label.class=label.BooleanLocalVariable\n
	label.BooleanLocalVariable.variable = RandomGraph.createDirectedGraph():isConnected\n
	@using=jpf-probabilistic\n
	listener=probabilistic.listener.StateSpaceText;label.StateLabelText"`
	cat > RandomDirectedGraphTest.jpf <<EOF
	${jpf_file}
EOF

	export JAVA_HOME=/opt/java/openjdk8
	export PATH="${JAVA_HOME}/bin:${ORIG_PATH}"
	/home/jpf/jpf-core/bin/jpf RandomDirectedGraphTest.jpf
	java JPFtoPRISM RandomDirectedGraphTest ../erdos-renyi_directed/erdosRenyiModelD${prob}
	
	export JAVA_HOME=/opt/java/openjdk
	export PATH="${JAVA_HOME}/bin:${ORIG_PATH}"
	/home/benchmarks/qvbs/prism-auto ../erdos-renyi_directed/ -p /home/prism/prism/bin/prism --args-list "-ex -bisim -new,-ex -bisim -robust" --log ../logs --log-subdir

	rm ../erdos-renyi_directed/erdosRenyiModelD${prob}.tra
	rm ../erdos-renyi_directed/erdosRenyiModelD${prob}.lab
	rm RandomDirectedGraphTest.jpf
	rm RandomDirectedGraphTest.tra
	rm RandomDirectedGraphTest.lab
done
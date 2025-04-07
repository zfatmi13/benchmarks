#!/bin/bash

# loop through size = 1, 2, ..., 200
for (( size = 4; size <= 9; size++ )); do
	
	jpf_file=`echo -e "target=QueensTest\n
	classpath=.\n
	target.args=1,${size}\n
	@using=jpf-label\n
	label.class=label.BooleanLocalVariable\n
	label.BooleanLocalVariable.variable=QueensTest.main(java.lang.String[]):success\n
	@using=jpf-probabilistic\n
	listener=probabilistic.listener.StateSpaceText;label.StateLabelText"`
	
	cat > QueensTest.jpf <<EOF
	${jpf_file}
EOF
	
	export JAVA_HOME=/opt/java/openjdk8
	export PATH="${JAVA_HOME}/bin:${ORIG_PATH}"
	/home/jpf/jpf-core/bin/jpf QueensTest.jpf -Xmx=8g
	# generate PRISM model file
	java JPFtoPRISM QueensTest ../queens/queens${size}
	
	export JAVA_HOME=/opt/java/openjdk
	export PATH="${JAVA_HOME}/bin:${ORIG_PATH}"
	/home/benchmarks/qvbs/prism-auto ../queens/ -p /home/prism/prism/bin/prism --args-list "-ex -bisim -new,-ex -bisim -robust" --log ../logs --log-subdir

	rm ../queens/queens${size}.tra
	rm ../queens/queens${size}.lab
	rm QueensTest.jpf
	rm QueensTest.tra
	rm QueensTest.lab
done

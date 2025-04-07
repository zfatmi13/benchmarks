#!/bin/bash

# set up initial value
trials=5
array_size=50

# loop through trials = 5, 10, ..., 100
# and array_length = 3,4, ..., 100
for (( zero_count = $((array_size / 2 + 1)); zero_count <= $((array_size - 1)); zero_count++ )); do
	
	# set up the zeros
	zero="0"
	for (( i = 1; i < $zero_count; i++ )); do
		zero="$zero,0"
	done

	# set up the ones
	one="1"
	for (( j = 1; j < $((array_size - zero_count)); j++ )); do
		one="$one,1"
	done

	array="$zero,$one"

	jpf_file=`echo -e "target=MajorityElementTest\n
	classpath=.\n
	target.args=${trials},${array}\n
	@using=jpf-label\n
	label.class=label.BooleanLocalVariable\n
	label.BooleanLocalVariable.variable=MajorityElementTest.main(java.lang.String[]):falsePositive\n
	@using=jpf-probabilistic\n
	listener=probabilistic.listener.StateSpaceText;label.StateLabelText"`
	cat > MajorityElementTest.jpf <<EOF
	${jpf_file}
EOF

	export JAVA_HOME=/opt/java/openjdk8
	export PATH="${JAVA_HOME}/bin:${ORIG_PATH}"
	/home/jpf/jpf-core/bin/jpf MajorityElementTest.jpf
	# generate PRISM model file
	java JPFtoPRISM MajorityElementTest ../has_majority_element/hasMajorityElement${zero_count}
	
	export JAVA_HOME=/opt/java/openjdk
	export PATH="${JAVA_HOME}/bin:${ORIG_PATH}"
	/home/benchmarks/qvbs/prism-auto ../has_majority_element/ -p /home/prism/prism/bin/prism --args-list "-ex -bisim -new,-ex -bisim -robust" --log ../logs --log-subdir

	rm ../has_majority_element/hasMajorityElement${zero_count}.tra
	rm ../has_majority_element/hasMajorityElement${zero_count}.lab
	rm MajorityElementTest.jpf
	rm MajorityElementTest.tra
	rm MajorityElementTest.lab
done

#!/bin/bash

universe_size=13

# set up max size for S and T
max_size=$(((universe_size - 1) /  2))

# loop through size = 1 to max_size
for (( s_t_size = 3; s_t_size <= max_size; s_t_size++ )); do
	# set up value for S
	s_first_element=0

	s_element="$s_first_element"

	for (( s_size = 1; s_size < s_t_size; s_size++ )); do
		s_element="$s_element,$s_size"
		s_first_element=$((s_first_element + 1))
	done

	# set up value for T
	t_first_element=$((s_first_element + 1))

	t_element="$t_first_element"

	for (( t_size = 1; t_size < s_t_size; t_size++ )); do
		t_rest_element=$((t_first_element + t_size))
		t_element="$t_element,$t_rest_element"
	done

#	echo $universe_size
#	echo $s_t_size
#	echo $s_element
#	echo $t_element

	jpf_file=`echo -e "target=SetIsolationTest\n
	classpath=.\n
	target.args=1,${universe_size},${s_t_size},${s_t_size},${s_element},${t_element}\n
	@using=jpf-label\n
	label.class=label.BooleanLocalVariable\n
	label.BooleanLocalVariable.variable=SetIsolationTest.main(java.lang.String[]):isGoodSample\n
	@using=jpf-probabilistic\n
	listener=probabilistic.listener.StateSpaceText;label.StateLabelText"`
	cat > SetIsolationTest.jpf <<EOF
	${jpf_file}
EOF
	
	export JAVA_HOME=/opt/java/openjdk8
	export PATH="${JAVA_HOME}/bin:${ORIG_PATH}"
	/home/jpf/jpf-core/bin/jpf SetIsolationTest.jpf -Xmx=8g
	java JPFtoPRISM SetIsolationTest ../set_isolation/setIsolation${s_t_size}

	export JAVA_HOME=/opt/java/openjdk
	export PATH="${JAVA_HOME}/bin:${ORIG_PATH}"
	/home/benchmarks/qvbs/prism-auto ../set_isolation/ -p /home/prism/prism/bin/prism --args-list "-ex -bisim -new,-ex -bisim -robust" --log ../set_isolation/logs --log-subdir

	rm ../set_isolation/setIsolation${s_t_size}.tra
	rm ../set_isolation/setIsolation${s_t_size}.lab
	rm SetIsolationTest.jpf
	rm SetIsolationTest.tra
	rm SetIsolationTest.lab
done
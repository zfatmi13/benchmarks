#!/bin/bash

# loop through number = 4, 6, ..., 5000
for (( i = 4000; i <= 5000; i++ )); do
	#store the number to be checked
	number=$i
	j=2
	#flag variable 
	f=0
	
	#running a loop from 2 to number/2 to check if it's prime
	while test $j -le `expr $number / 2`  
	do
		#checking if i is factor of number 
		if test `expr $number % $j` -eq 0  
		then
			f=1 
		fi
		#increment the loop variable 
		j=`expr $j + 1` 
	done

	# if it's not a prime (f=1)
	if test $f -eq 1  
	then
		jpf_file=`echo -e "target=PollardFactoringTest\n
		classpath=.\n
		target.args=${number}\n
		@using=jpf-label\n
		label.class=label.BooleanLocalVariable\n
		label.BooleanLocalVariable.variable=PollardFactoringTest.main(java.lang.String[]):sameAsInput\n
		@using=jpf-probabilistic\n
		listener=probabilistic.listener.StateSpaceText;label.StateLabelText"`
		cat > PollardFactoringTest.jpf <<EOF
		${jpf_file}
EOF
		# run JPF
		/home/jpf/jpf-core/bin/jpf PollardFactoringTest.jpf
		# generate PRISM model file
		java JPFtoPRISM PollardFactoringTest ../pollards_factorization/pollardsFactorization${number}
		/home/benchmarks/qvbs/prism-auto ../pollards_factorization/ -p /home/prism/prism/bin/prism --args-list "-ex -bisim -new,-ex -bisim -robust" --log ../logs --log-subdir

		rm ../pollards_factorization/pollardsFactorization${number}.tra
		rm ../pollards_factorization/pollardsFactorization${number}.lab
		rm PollardFactoringTest.jpf
		rm PollardFactoringTest.tra
		rm PollardFactoringTest.lab
	else
		continue
	fi
done

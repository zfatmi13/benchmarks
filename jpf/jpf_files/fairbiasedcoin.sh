#!/bin/bash

bias=0
# loop through bias = 0.1, 0.2, ..., 0.9
for (( i = 1; i <= 9; i++ )); do
	bias=$(echo "$bias + 0.1"|bc)

	jpf_file=`echo -e "target=FairBiasedCoinTest\n
	classpath=.\n
	target.args=${bias}\n
	@using=jpf-label\n
	label.class=label.BooleanLocalVariable\n
	label.BooleanLocalVariable.variable=FairBiasedCoinTest.main(java.lang.String[]):isHead\n
	@using=jpf-probabilistic\n
	listener=probabilistic.listener.StateSpaceText;label.StateLabelText"`
	cat > FairBiasedCoinTest.jpf <<EOF
	${jpf_file}
EOF
	# run JPF
	/home/jpf/jpf-core/bin/jpf FairBiasedCoinTest.jpf
	# generate PRISM model file
	java JPFtoPRISM FairBiasedCoinTest ../fair_biased_coin/fairBiasedCoin${bias}
	/home/benchmarks/qvbs/prism-auto ../fair_biased_coin/ -p /home/prism/prism/bin/prism --args-list "-ex -bisim -new,-ex -bisim -robust" --log ../logs --log-subdir

	rm ../fair_biased_coin/fairBiasedCoin${bias}.tra
	rm ../fair_biased_coin/fairBiasedCoin${bias}.lab
	rm FairBiasedCoinTest.jpf
	rm FairBiasedCoinTest.tra
	rm FairBiasedCoinTest.lab
done
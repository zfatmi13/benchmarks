#!/bin/bash

/home/jpf/jpf-core/bin/jpf table4.jpf -Xmx=8g
java JPFtoPRISM QueensTest ../queens/queens10
/home/benchmarks/qvbs/prism-auto ../queens/ -p /home/prism/prism/bin/prism --args-list "-ex -bisim -new" --log ../queens/logs --log-subdir

rm ../queens/queens10.tra
rm ../queens/queens10.lab
rm QueensTest.jpf
rm QueensTest.tra
rm QueensTest.lab

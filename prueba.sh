#!/bin/bash
for i in {0..13}
do
perf stat -r40 -o ./datos/runtime/d4n$i.dat ./myVegas -d 4 -n $i -a 1 -i 10 > /dev/null
done

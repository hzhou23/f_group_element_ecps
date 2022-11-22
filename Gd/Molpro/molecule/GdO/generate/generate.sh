#!/bin/bash

equil=$(echo "1.1" | bc -l)
d=$(echo "0.10" | bc -l)

HOME=`pwd`

basefolder=$HOME/..
n=15

for i in ECP10
do
	echo $i
        mkdir $basefolder/$i
for ((j=0; j<=n; j++))
do
	r=$(echo "$equil+$j*$d" | bc -l)
	mkdir $basefolder/$i/r_$r
	cp $HOME/job $basefolder/$i/r_$r
	cp $HOME/$i.com $basefolder/$i/r_$r/tz.com
	cp $HOME/run $basefolder/$i/run
	#cp $HOME/*.basis $basefolder/r_$r/
	sed -i "s/length/$r/g" $basefolder/$i/r_$r/tz.com
	sed -i "s/ecp/$i/g" $basefolder/$i/r_$r/job
	sed -i "s/length/$r/g" $basefolder/$i/r_$r/job
done
done

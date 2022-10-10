#!/bin/bash

HOME=`pwd`

n=16

rm $HOME/tz.table1.csv

echo 'SCF,CCSD' > $HOME/tz.table1.csv

for ((i=1;i<=n;i++))
do
	cd $HOME/$i
	echo $i
	grep '-' tz.table1.csv | awk '{print $1 $2}' >> $HOME/tz.table1.csv
done

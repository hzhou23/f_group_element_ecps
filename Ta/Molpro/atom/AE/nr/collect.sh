#!/bin/bash

HOME=`pwd`

n=17

rm $HOME/tz.table1.csv

echo 'SCF' > $HOME/tz.table1.csv

for ((i=1;i<=n;i++))
do
	cd $HOME/$i
	grep '-' tz.table1.csv | awk '{print $1}' >> $HOME/tz.table1.csv
done

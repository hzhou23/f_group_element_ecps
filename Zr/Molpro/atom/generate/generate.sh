#!/bin/bash


HOME=`pwd`

basefolder=$HOME/..

for i in crenbl crenbs sbkjc mwbstu mdfstu lanl2 ECP1
do
	echo $i
	mkdir $basefolder/$i
	cp $HOME/job $basefolder/$i/
	cp $HOME/$i.com $basefolder/$i/tz.com
	cp $HOME/run $basefolder/run
	sed -i "s/ecp/$i/g" $basefolder/$i/job
done

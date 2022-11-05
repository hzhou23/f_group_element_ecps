#!/bin/bash

HOME=`pwd`

n=8

for ((i=1; i<=n; i++))
do
	mkdir $HOME/$i
	cp $HOME/job $HOME/$i
	cp $HOME/template.com $HOME/$i/tz.com
	#cp $HOME/*.basis $basefolder/r_$r/
        sed -i "s/NUM/$i/g" $HOME/$i/tz.com
	sed -i "s/NUM/$i/g" $HOME/$i/job
done

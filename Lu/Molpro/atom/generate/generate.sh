
#!/bin/bash


HOME=`pwd`

basefolder=$HOME/..

for i in ECP605s ECP605p ECP605d
do
	echo $i
	mkdir $basefolder/$i
	cp $HOME/job $basefolder/$i/
	cp $HOME/$i.com $basefolder/$i/tz.com
	cp $HOME/run $basefolder/run
	sed -i "s/ecp/$i/g" $basefolder/$i/job
done

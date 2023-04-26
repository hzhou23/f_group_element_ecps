
#!/bin/bash


HOME=`pwd`

basefolder=$HOME/..

for i in messyminus ccpwCVDZdk3 ccpwCVDZx2c ccpwCVTZdk3 ccpwCVTZx2c ccpwCVQZdk3 ccpwCVQZx2c SapDZdiff SapTZdiff SapQZdiff AHGBS9 AHGBS7 AHGBS5
do
	echo $i
	mkdir $basefolder/$i
	cp $HOME/run_all $basefolder/$i
	cp $HOME/collect.sh $basefolder/$i
	cd $basefolder/$i
	for j in $(seq 1 17)
	do
		mkdir $basefolder/$i/$j
		cp $HOME/template.com $basefolder/$i/$j/tz.com
		cp $HOME/job $basefolder/$i/$j/job
		sed -i "s/NAMEOFB/$i/g" $basefolder/$i/$j/tz.com
		sed -i "s/NUM/$j/g" $basefolder/$i/$j/tz.com
		sed -i "s/NAMEOFB/$i/g" $basefolder/$i/$j/job
		sed -i "s/NUM/$j/g" $basefolder/$i/$j/job
	done
done

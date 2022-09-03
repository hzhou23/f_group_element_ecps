#!/bin/bash -l
#This script is written to collect the data of TZ basis binding energy


HOME=`pwd`

for j in AE UC crenbl  lanl2  mdfstu  sbkjc  ECP mwbstu
do
echo $j
rm $HOME/$j/tzbind
echo r bind > $HOME/$j/tzbind
for i in $(seq 1.10 0.10 2.10 )
do
cd $HOME/$j/r_$i
Ebind=$(awk '{print $4}' tz.table1.txt)
echo $i $Ebind >> $HOME/$j/tzbind
done
cat $HOME/$j/tzbind
done


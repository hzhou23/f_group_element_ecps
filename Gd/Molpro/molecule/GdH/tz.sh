
#!/bin/bash -l
#This script is written to collect the data of TZ basis binding energy


HOME=`pwd`

for j in UC ECP17 ECP17new
do
echo $j
rm $HOME/$j/tzbind
echo r bind > $HOME/$j/tzbind
for i in $(seq 1.10 0.10 2.60 )
do
cd $HOME/$j/r_$i
Ebind=$(awk '{print $4}' tz.table1.txt)
echo $i $Ebind >> $HOME/$j/tzbind
done
cat $HOME/$j/tzbind
done

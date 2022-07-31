#!/bin/bash -l

HOME=`pwd`
rm states.spect
rm states.gap 
rm *h5
rm *out
rm *dat
rm *degen

my_mol="tz"
pam --noarch --gb=8 --inp=core.inp --mol=${my_mol}.mol --get "DFCOEF=coreDFCOEF"

declare -a states=("gs" "f8s2d1" "f9s1" "f9" "f8d1" "f8p1")

### First, calculate all states in parallel
for i in "${states[@]}"
do
	#pam --noarch --gb=8 --inp=${i}.inp --mol=${my_mol}.mol --put "${i}DFCOEF=DFCOEF" --get "DFCOEF=${i}DFCOEF" &
	pam --noarch --gb=8 --inp=${i}.inp --mol=${my_mol}.mol --put "coreDFCOEF=DFCOEF" --get "DFCOEF=${i}DFCOEF" &
	#pam --noarch --gb=8 --inp=${i}.inp --mol=${my_mol}.mol --put "${i}DFCOEF=DFCOEF" &
done
wait

for i in "${states[@]}"
do
	#pam --noarch --gb=8 --inp=${i}.inp --mol=${my_mol}.mol --put "coreDFCOEF=DFCOEF" --get "DFCOEF=${i}DFCOEF"

	lineBegin=$(grep -n 'Total Energy'  ${i}_${my_mol}.out | head -n 1 | cut -d: -f1)
	lineEnd=$(grep -n 'Total average' ${i}_${my_mol}.out | head -n 1 | cut -d: -f1)
	
	if [ -z $lineBegin ]
		then
		#### Read the calculation without SO splitting ####
		echo "$i state, No SO splitting in this state"
		grep 'Total energy' ${i}_${my_mol}.out | head -n 1 | awk '{print $4}' > $i.dat
		awk 'NR==1{print}' $i.dat >> states.spect
		else
		#### Read the calculation with SO splitting ####
		echo "$i state, SO split reading..."
		lineSOBegin="$[lineBegin + 2]"
		lineSOEnd="$[lineEnd - 3]"
		awk "NR>=$lineSOBegin&&NR<=$lineSOEnd{print}" ${i}_${my_mol}.out | awk '{print $4}' > $i.dat
		awk "NR>=$lineSOBegin&&NR<=$lineSOEnd{print}" ${i}_${my_mol}.out | awk '{print $6}' > $i.degen
		awk 'NR==1{print}' $i.dat >> states.spect
	fi
done


gs=`awk 'NR==1{print $1}' states.spect`
awk -v ref=$gs '{printf("%.12f\n",($1-ref)*27.2113862127)}' states.spect > states.gap
for i in "${states[@]}"
do
	linenum=$(grep "" -c $i.dat)
	if [ $linenum != 1 ]
	then
		ref=`awk 'NR==1{print $1}' $i.dat`
		awk -v ref=$ref '{printf("%.12f\n",($1-ref)*27.2113862127)}' $i.dat >> states.gap
	fi
done

rm -r DIRAC*



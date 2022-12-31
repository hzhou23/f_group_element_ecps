#!/usr/bin/bash

rm rccsdt.csv
rm rccsdT.csv
rm RCCSDT.csv

echo 'r AE UC ECP17' >> rccsdt.csv
echo 'r AE UC ECP17' >> rccsdT.csv
echo 'r AE UC ECP17' >> RCCSDT.csv


for j in $(seq 1.30 0.1 2.50)
do
	ECPrccsdt=$(grep '!RHF-RCCSD(T)' ./ECP17/r_$j/tz.out | awk '{print $3}') 
	ECPrccsdT=$(grep 'RHF-RCCSD\[T]' ./ECP17/r_$j/tz.out | awk '{print $3}')
	ECPRCCSDT=$(grep 'RHF-RCCSD-T' ./ECP17/r_$j/tz.out | awk '{print $3}')
	UCrccsdt=$(grep '!RHF-RCCSD(T)' ./UC/r_$j/tz.out | awk '{print $3}')
	UCrccsdT=$(grep 'RHF-RCCSD\[T]' ./UC/r_$j/tz.out | awk '{print $3}')
	UCRCCSDT=$(grep 'RHF-RCCSD-T' ./UC/r_$j/tz.out | awk '{print $3}')
	AErccsdt=$(grep '!RHF-RCCSD(T)' ./AE/r_$j/tz.out | awk '{print $3}')
	AErccsdT=$(grep 'RHF-RCCSD\[T]' ./AE/r_$j/tz.out | awk '{print $3}')
	AERCCSDT=$(grep 'RHF-RCCSD-T' ./AE/r_$j/tz.out | awk '{print $3}')
	echo $j $AErccsdt $UCrccsdt $ECPrccsdt >> rccsdt.csv
	echo $j $AErccsdT $UCrccsdT $ECPrccsdT >> rccsdT.csv
	echo $j $AERCCSDT $UCRCCSDT $ECPRCCSDT >> RCCSDT.csv
done


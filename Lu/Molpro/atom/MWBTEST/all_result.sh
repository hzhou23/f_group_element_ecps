
#!/bin/bash -l
#This script is written to collect the data of TZ basis binding energy


HOME=`pwd`

for j in messyminus ccpwCVDZdk3 ccpwCVDZx2c ccpwCVTZdk3 ccpwCVTZx2c ccpwCVQZdk3 ccpwCVQZx2c SapDZdiff SapTZdiff SapQZdiff AHGBS9 AHGBS7 AHGBS5
do
echo $j
cd $HOME/$j
bash collect.sh
done

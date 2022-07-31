#!/bin/bash

rm results.out

echo "Parameters:"
cat params.in

pexp1=`grep  'x1 '  params.in | awk '{print $1}'`
pcoef1=`grep 'x2 '  params.in | awk '{print $1}'`

dexp1=`grep  'x3 '  params.in | awk '{print $1}'`
dcoef1=`grep 'x4 '  params.in | awk '{print $1}'`

fexp1=`grep  'x5 '  params.in | awk '{print $1}'`
fcoef1=`grep 'x6 '  params.in | awk '{print $1}'`

cp ../blank.mol tz.mol

sed -i "s/pexp1/$pexp1/g"   tz.mol
sed -i "s/pcoef1/$pcoef1/g"   tz.mol

sed -i "s/dexp1/$dexp1/g"   tz.mol
sed -i "s/dcoef1/$dcoef1/g"   tz.mol

sed -i "s/fexp1/$fexp1/g"   tz.mol
sed -i "s/fcoef1/$fcoef1/g"   tz.mol

cp tz.mol ../dirac/tz.mol
cd ../dirac
bash calc.sh > slurm.out
python run.py > log.out
#cp log.out ../.
cp results.out ../donlp2/
cd ../donlp2/


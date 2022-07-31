#!/bin/bash

echo "Parameters:"
cat params.in

#Zeff=`grep   'x1 '  params.in | awk '{print $1}'`
Zeff=19.00
alpha=`grep  'x1 '  params.in | awk '{print $1}'`
beta=`grep   'x2 '  params.in | awk '{print $1}'`
delta1=`grep 'x3 '  params.in | awk '{print $1}'`
gamma1=`grep 'x4 '  params.in | awk '{print $1}'`
delta2=`grep 'x5 '  params.in | awk '{print $1}'`
gamma2=`grep 'x6 '  params.in | awk '{print $1}'`

sexp1=`grep  'x7 '  params.in | awk '{print $1}'`
scoef1=`grep 'x8 '  params.in | awk '{print $1}'`
sexp2=`grep  'x9 '  params.in | awk '{print $1}'`
scoef2=`grep 'x10'  params.in | awk '{print $1}'`

pexp1=`grep  'x11'  params.in | awk '{print $1}'`
pcoef1=`grep 'x12'  params.in | awk '{print $1}'`
pexp2=`grep  'x13'  params.in | awk '{print $1}'`
pcoef2=`grep 'x14'  params.in | awk '{print $1}'`

dexp1=`grep  'x15'  params.in | awk '{print $1}'`
dcoef1=`grep 'x16'  params.in | awk '{print $1}'`
dexp2=`grep  'x17'  params.in | awk '{print $1}'`
dcoef2=`grep 'x18'  params.in | awk '{print $1}'`

fexp1=`grep  'x19'  params.in | awk '{print $1}'`
fcoef1=`grep 'x20'  params.in | awk '{print $1}'`
fexp2=`grep  'x21'  params.in | awk '{print $1}'`
fcoef2=`grep 'x22'  params.in | awk '{print $1}'`

Zxa=$(echo "$Zeff*$alpha" | bc -l)

sed "s/alpha/$alpha/g" ../blank.d > pp.d
sed -i "s/beta/$beta/g"     pp.d  
sed -i "s/delta1/$delta1/g" pp.d
sed -i "s/gamma1/$gamma1/g" pp.d
sed -i "s/delta2/$delta2/g" pp.d
sed -i "s/gamma2/$gamma2/g" pp.d

sed -i "s/sexp1/$sexp1/g"   pp.d
sed -i "s/scoef1/$scoef1/g" pp.d
sed -i "s/sexp2/$sexp2/g"   pp.d
sed -i "s/scoef2/$scoef2/g" pp.d

sed -i "s/pexp1/$pexp1/g"   pp.d
sed -i "s/pcoef1/$pcoef1/g" pp.d
sed -i "s/pexp2/$pexp2/g"   pp.d
sed -i "s/pcoef2/$pcoef2/g" pp.d

sed -i "s/dexp1/$dexp1/g"   pp.d
sed -i "s/dcoef1/$dcoef1/g" pp.d
sed -i "s/dexp2/$dexp2/g"   pp.d
sed -i "s/dcoef2/$dcoef2/g" pp.d

sed -i "s/fexp1/$fexp1/g"   pp.d
sed -i "s/fcoef1/$fcoef1/g" pp.d
sed -i "s/fexp2/$fexp2/g"   pp.d
sed -i "s/fcoef2/$fcoef2/g" pp.d

sed -i "s/Zeff/$Zeff/g"     pp.d
sed -i "s/Zxa/$Zxa/g"       pp.d

cp pp.d ../inputs/pp.d

#### NORM RELATED
#MY_ECP=`cat pp.d`
#cp ../blank.param ../opium_norm/Tb.param
#sed -i "s/MY_ECP/${MY_ECP//$'\n'/\\n}/g" ../opium_norm/Tb.param

rm results.out
cd ../inputs

python run.py > log.out
cp log.out ../.

#stout=`grep -ic error log.out`
#
#if [ $stout -gt 0 ]; then
#  tail log.out
#  echo "Error in Run."
#  echo "Error in Run." > results.out
#else
#  echo "Clean Run. Spectrum residuals:"
#  cat results.out
#  echo " "
#fi

cp results.out ../donlp2/
cd ../donlp2/


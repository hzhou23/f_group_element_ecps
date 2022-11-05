***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 9.47542488781723 , 13.0
3, 6.69638523920446 , 123.180523541623990
2, 4.49665188987648 , -4.74557294171347
2, 5.30234697006755 , -7.51033246908528
4
2, 12.98757659063021,  254.44131772608694
4, 5.17648717888461 , 3.15577270320956
2, 2.46430257337332 , -2.97108487311425
2, 4.38156727576169 , 14.21301049236293
4
2, 10.85433613775534,  292.80349866418817
4, 8.95319690470203 , 11.07740577773581
2, 5.04773343191292 , -2.00527054255383
2, 5.34475616661697 , 12.09962007935479
4
2, 7.40231078774127 , 115.53263438293220
4, 5.88160011745925 , 1.27562444911800
2, 1.64930583666440 , 0.07883881063929
2, 4.62279215188138 , 12.40307009357823
2
2, 4.26309031604805 , 13.45946109609858
2, 2.18866111514022 , 13.01299649099056
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.27851149
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 14
symm = 1
ss= 4

!There are irrep cards paramters
A1=4
B1=2
B2=2
A2=1


geometry={
    2
    TaH molecule
    Ta 0.0 0.0 0.0
    H 0.0 0.0 1.10
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1-1,B2-1,A2-1
 sym,1,1,1,1,2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Ta_ccsd-H_ccsd


table,1.10,scf,ccsd,bind
save
type,csv


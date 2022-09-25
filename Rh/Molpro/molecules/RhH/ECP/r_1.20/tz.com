***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, rh, 28, 3
4
1,  25.35578461140435,  17.0
3,  26.05263956821224,  431.048338393873950
2,  8.46323569001768 , -12.82792282127235
2,  10.42966551681324,  -14.58600180692448
2
2,  11.97743147803048,  247.18752221221021
2,  5.28969649185796 , 32.54422721537352
2
2,  10.11647315550102,  182.02540368081245
2,  6.09541744449244 , 33.30006655886067
2
2,  8.97279999573378 , 80.93612270509061
2,  3.72295346630952 , 11.02024401138006
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Rh-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Rh_ccsd=-110.03538648
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 18
symm = 1
ss= 2

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    RhH molecule
    Rh 0.0 0.0 0.0
    H 0.0 0.0 1.20
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Rh_ccsd-H_ccsd


table,1.20,scf,ccsd,bind
save
type,csv


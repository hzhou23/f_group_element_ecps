***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, rh, 28, 3
4
1, 22.80620553159304,  17.0
3, 32.71000635592747,  387.705494037081680
2, 14.04858672478363,  -10.57196656168149
2, 11.83833524886781,  -14.59446052899020
2
2, 11.96851556026113,  245.38791874527365
2, 5.12576018874406 , 27.28583987118665
2
2, 9.73960036628028 , 180.58942316852949
2, 6.56477618290695 , 28.41162810130719
2
2, 11.42592077796438,  83.48704442041299
2, 4.50252107517308 , 21.38037165422960
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Rh-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Rh_ccsd=-110.01573081
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
    H 0.0 0.0 2.10
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


table,2.10,scf,ccsd,bind
save
type,csv


***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Lu, 60, 3 ;
4
1, 10.71958253928560,   11.0
3, 14.88372328066933,   117.915407932141600
2, 4.11287467993412 ,  -6.34823518602368
2, 2.75732780170156 ,  -3.70029973760982
2
2, 9.23377298305889 , 141.15765155788728
2, 2.87295917112923 ,  12.86491956302655
2
2, 7.79648674392374 ,  81.17091453527206
2, 2.95493071586336 ,  16.13959136431034
2
2, 5.45152731011908 ,  55.30590183974553
2, 2.49895229788774 ,  5.11316712615671
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/messyminus.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Lu_ccsd=-40.32208276
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 12
symm = 1
ss= 0

!There are irrep cards paramters
A1=4
B1=1
B2=1
A2=0


geometry={
    2
    LuH molecule
    Lu 0.0 0.0 0.0
    H 0.0 0.0 1.20
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Lu_ccsd-H_ccsd


table,1.20,scf,ccsd,bind
save
type,csv


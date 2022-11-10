***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
4
1, 10.67500623817997,  15.0
3, 7.85819766729660 , 160.125093572699550
2, 3.36863140426786 , -12.31293775865530
2, 4.17451338014344 , -12.29041899386033
2
2, 11.19308477006133,  349.55585223560087
2, 3.41917553761499 , 14.90976824860685
2
2, 8.66070891213721 , 339.73940989598162
2, 5.79757307586202 , 42.33143667783385
2
2, 6.98790989708612 , 110.41142229825637
2, 3.12000599379110 , 19.87299374014431
2
2, 2.63694647910722 , 16.47403739377819
2, 3.60972449382580 , 16.52458176381737
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Re_ccsd=-78.04811686
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 16
symm = 1
ss= 4

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    ReH molecule
    Re 0.0 0.0 0.0
    H 0.0 0.0 1.90
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
bind=ccsd-Re_ccsd-H_ccsd


table,1.90,scf,ccsd,bind
save
type,csv


***,Calculation for Re atom, singlet and triplet
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
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Re_ccsd=-78.04811686
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 21
symm = 1
ss= 5

!There are irrep cards paramters
A1=6
B1=3
B2=3
A2=1


geometry={
    2
    ReO molecule
    Re 0.0 0.0 0.0
    O 0.0 0.0 2.20
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Re_ccsd-O_ccsd


table,2.20,scf,ccsd,bind
save
type,csv


***,Calculation for Re atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
4
1, 14.43854659147721,  15.0
3, 13.70108435455064,  216.578198872158150
2, 3.29012267081750 , -5.49791114613269
2, 4.19180006657470 , -6.70046168985070
2
2, 12.10953143571472,  471.14756017907325
2, 3.41581208431076 , 15.23767681280703
2
2, 9.38138638056830 , 265.34191199047200
2, 5.25951321712640 , 49.14984326818383
2
2, 5.97608287438998 , 108.77986912107261
2, 4.73102802203891 , 33.35431558891830
2
2, 2.23002266600839 , 16.91896604085085
2, 4.13208395739172 , 17.85440910215242
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


Re_ccsd=-78.24433292
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
    O 0.0 0.0 1.70
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


table,1.70,scf,ccsd,bind
save
type,csv


***,Calculation for Re atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
4
1, 14.43859050560659,  15.0
3, 13.70010424744015,  216.578857584098850
2, 3.29949225443510 , -5.49542838823487
2, 4.19747661299732 , -6.69907643242339
2
2, 12.09962270113623,  471.14758011601452
2, 3.40670223061467 , 15.23862058351030
2
2, 9.37756238294759 , 265.34194798602869
2, 5.25346813206030 , 49.15007833631903
2
2, 5.96856851785967 , 108.77998936694145
2, 4.72533636571819 , 33.35457410112623
2
2, 2.23014944429660 , 16.91896014729894
2, 4.13209659525014 , 17.85440822965785
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


Re_ccsd=-78.18319072
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
    O 0.0 0.0 2.60
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


table,2.60,scf,ccsd,bind
save
type,csv


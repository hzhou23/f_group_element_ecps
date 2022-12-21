***,Calculation for GdO, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Gd, 46, 4 ;
4
1, 4.00344854305685  ,  18.0
3, 3.60717766063765  ,  72.062073775
2, 5.21365732868997  ,  -102.20002007755825
2, 2.18770217170469  ,  -14.75807024866064
2
2, 15.19768280892150 ,  164.26842010886315
2, 4.22792214772802  ,  94.10201308425050
2
2, 11.34094238963603 ,  85.78533109242058
2, 3.71806799706924  ,  80.17668767976696
2
2, 8.48307462992686  ,  52.37778970757638
2, 2.34176280592863  ,  33.91095382043715
2
2, 3.25436714839169  ,  -5.98801545860119
2, 2.89616097318773  ,  -0.04688074964155
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


Gd_ccsd=-109.0152961
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 24
symm = 4
ss= 8

!There are irrep cards paramters
A1=7
B1=4
B2=4
A2=1


geometry={
    2
    GdO molecule
    Gd 0.0 0.0 0.0
    O 0.0 0.0 1.10
}
{rks,pbe0,maxdis=30,nitord=50;
 start,atden
 maxit,200;
 wf,ne-1,symm,ss-1
 occ,A1-1,B1,B2,A2
 closed,A1-3,B1-2,B2-2,A2-1
 print,orbitals=2
 orbital,2202.2
}
{rhf,nitord=60;
 start,2202.2
 maxit,200;
 wf,ne-1,symm,ss-1
 occ,A1-1,B1,B2,A2
 closed,A1-3,B1-2,B2-2,A2-1
 print,orbitals=2
 orbital,3202.2
}
{rks,pbe0,maxdis=30,nitord=50;
 start,3202.2
 maxit,200;
 shift,-2.0,-1.0
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-3,B1-2,B2-2,A2-1
 print,orbitals=2
 orbital,4202.2
}
{rhf,nitord=60;
 start,4202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-3,B1-2,B2-2,A2-1
 print,orbitals=2
 orbital,5202.2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Gd_ccsd-O_ccsd


table,1.10,scf,ccsd,bind
save
type,csv


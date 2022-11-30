***,Calculation for GdO, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Gd, 46, 4 ;
4
1, 4.64649423380707,  18.0
3, 5.03898469561614,  83.636896208527260
2, 6.14922726155977,  -94.54346463109100
2, 5.39086597594697,  -9.07764978300212
2
2, 9.64508287717261,  160.08091893942253
2, 4.89569161141406,  82.16244181564230
2
2, 7.84634259934576,  88.42449114602753
2, 3.73740426162130,  54.36568213794933
2
2, 9.87079385121206,  55.57793911614991
2, 2.47059638061654,  31.33022231606614
2
2, 3.70555603254771,  -25.69937903186067
2, 6.16350930047429,  -4.52646585527923
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


Gd_ccsd=-109.2993715
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
    O 0.0 0.0 2.00
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


table,2.00,scf,ccsd,bind
save
type,csv


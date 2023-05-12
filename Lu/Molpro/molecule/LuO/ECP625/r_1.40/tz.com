**,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,Lu,60, 3;
4
1, 10.23485920282456,   11.0
3, 14.49362898663644,   112.583451231070160
2, 1.99669342423049 ,  -4.11518361607157
2, 1.52219558082155 ,  -5.99817853440891
2
2, 8.40537143117621 , 140.76563700236869
2, 1.48226049394534 ,  9.52713981212061
2
2, 8.11532667347111 ,  81.64503592075995
2, 1.78869880933605 ,  14.78047185327683
2
2, 3.50718454524300 ,  55.64832230347650
2, 2.54490607793683 ,  8.32394652648653
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/messyminus.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Lu_ccsd=-40.48304271
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 17
symm = 1
ss= 1

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=0


geometry={
    2
    LuO molecule
    Lu 0.0 0.0 0.0
    O 0.0 0.0 1.40
}
{rhf,nitord=60;
 start,atden
 maxit,200;
 wf,ne-1,symm,ss-1
 occ,A1-1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
 orbital,2202.2
}
{rhf,nitord=60;
 start,2202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
 orbital,3202.2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Lu_ccsd-O_ccsd


table,1.40,scf,ccsd,bind
save
type,csv


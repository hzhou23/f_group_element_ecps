***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,Zr,28,3
4
1, 16.98857135215762,  12.0
3, 16.45017512601250,  203.862856225891440
2, 4.17003168118445 , -13.49418435319915
2, 14.58119965632844,  -10.23466856641662
2
2, 9.00676171417253 , 150.09834066417420
2, 3.64409522087210 , 28.90663531474614
2
2, 7.59239715590237 , 99.35683485898602
2, 3.41969515065976 , 22.98527159164662
2
2, 2.31017546162010 , 7.16789331264605
2, 5.56384526072832 , 47.42620459352956
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Zr-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Zr_ccsd=-46.74495773
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 13
symm = 2
ss= 1

!There are irrep cards paramters
A1=4
B1=2
B2=1
A2=0


geometry={
    2
    YH molecule
    Zr 0.0 0.0 0.0
    H 0.0 0.0 1.90
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Zr_ccsd-H_ccsd


table,1.90,scf,ccsd,bind
save
type,csv


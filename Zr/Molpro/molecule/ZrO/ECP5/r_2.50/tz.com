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
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/Zr-aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Zr_ccsd=-46.74495773
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 18
symm = 1
ss= 0

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=0


geometry={
    2
    ZrO molecule
    Zr 0.0 0.0 0.0
    O 0.0 0.0 2.50
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
bind=ccsd-Zr_ccsd-O_ccsd


table,2.50,scf,ccsd,bind
save
type,csv


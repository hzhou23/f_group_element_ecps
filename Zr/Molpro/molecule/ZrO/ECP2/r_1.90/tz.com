***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, zr, 28, 3
4
1, 24.93662480058556,  12.0
3, 25.60138912529493,  299.239497607026720
2, 4.63133282245088 , -6.69423161135365
2, 4.63375542839619 , -9.42600811679514
2
2, 8.89489066167732 , 150.29849964177808
2, 3.71262281466892 , 29.71650849817421
2
2, 7.63087129023482 , 98.93670075791026
2, 3.50755991017841 , 24.52374255152788
2
2, 2.28260795413667 , 5.99168140315980
2, 5.24636950495757 , 46.95144310032716
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


Zr_ccsd=-46.74672029
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
    O 0.0 0.0 1.90
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


table,1.90,scf,ccsd,bind
save
type,csv


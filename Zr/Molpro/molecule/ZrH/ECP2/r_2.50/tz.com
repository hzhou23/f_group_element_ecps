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
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Zr-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Zr_ccsd=-46.74672029
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
    H 0.0 0.0 2.50
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


table,2.50,scf,ccsd,bind
save
type,csv


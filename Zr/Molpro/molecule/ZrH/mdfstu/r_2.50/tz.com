***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,Zr,28,4,0;
1; 2,1.000000,0.000000;
2; 2,8.636528,150.242994; 2,3.717639,18.780036;
4; 2,7.626728,33.192791; 2,7.453207,66.389039; 2,3.358389,4.620726; 2,3.229738,9.260270;
4; 2,5.938086,13.993383; 2,5.825544,20.995882; 2,2.205019,2.285166; 2,2.206292,3.441260;
2; 2,4.800215,-5.239320; 2,4.798992,-6.987424;
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Zr-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Zr_ccsd=-46.69636260
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 13
symm = 1
ss= 1

!There are irrep cards paramters
A1=5
B1=1
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
 closed,A1-1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Zr_ccsd-H_ccsd


table,2.50,scf,ccsd,bind
save
type,csv


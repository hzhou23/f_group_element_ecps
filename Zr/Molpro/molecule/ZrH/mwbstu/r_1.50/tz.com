***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,Zr,28,4,0;
1; 2,1.000000,0.000000;
2; 2,8.200000,150.267591; 2,4.089728,18.976216;
2; 2,7.110000,99.622124; 2,3.596798,14.168733;
2; 2,5.350000,35.045124; 2,2.491821,6.111259;
2; 2,7.540000,-21.093776; 2,3.770000,-3.080694;
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Zr-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Zr_ccsd=-46.83345410
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
    H 0.0 0.0 1.50
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


table,1.50,scf,ccsd,bind
save
type,csv


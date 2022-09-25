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
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/Zr-aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pVTZ.basis
}


Zr_ccsd=-46.83345410
O_ccsd=-15.85572648

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
    O 0.0 0.0 1.20
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


table,1.20,scf,ccsd,bind
save
type,csv


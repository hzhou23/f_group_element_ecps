***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, rh, 28, 3 ;
1; !  ul potential
1,7.6496800,-8.1322500;
3; !  s-ul potential
0,1.3377700,5.2077300;
2,2.9530800,-50.0684600;
2,4.3913100,90.3685900;
3; !  p-ul potential
0,1.1946800,3.8587400;
2,2.9243400,-72.7434800;
2,3.6750300,106.1161500;
2; !  d-ul potential
0,17.8924800,3.3482500;
2,5.3487400,47.1388300;
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Rh-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Rh_ccsd=-109.94692643
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 18
symm = 1
ss= 2

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    RhH molecule
    Rh 0.0 0.0 0.0
    H 0.0 0.0 1.20
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Rh_ccsd-H_ccsd


table,1.20,scf,ccsd,bind
save
type,csv


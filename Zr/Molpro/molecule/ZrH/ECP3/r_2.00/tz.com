***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, zr, 28, 3
4
1, 23.99901156399985,  12.0
3, 25.97176391420234,  287.988138767998200
2, 4.92661418289814 , -5.98717813175362
2, 4.80138762543713 , -7.92258037931769
2
2, 8.76509116700506 , 150.26231364732385
2, 3.92832199983719 , 30.21371302162681
2
2, 7.41790671408941 , 99.30190953603842
2, 3.76873307676204 , 25.35602553401884
2
2, 2.25055569071831 , 5.62570696446559
2, 5.35535567613690 , 46.91683292558112
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Zr-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Zr_ccsd=-46.74018292
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
    H 0.0 0.0 2.00
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


table,2.00,scf,ccsd,bind
save
type,csv


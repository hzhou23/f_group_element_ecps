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


Zr_ccsd=-46.74018292
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
    O 0.0 0.0 2.40
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


table,2.40,scf,ccsd,bind
save
type,csv


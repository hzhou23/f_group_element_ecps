***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Lu, 60, 4 ;
4
1,  15.28440259526261, 11.0
3,  12.57643855801481, 168.128428547888710
2,  4.89951641455830 , -7.06296873511447
2,  4.58599893504871 , -4.35500944858352
2
2,  14.87229120189673, 470.61534293686435
2,  8.75060718690670 , 170.12357705579251
2
2,  8.12000000000000 , 222.37803784363908
2,  3.85150180895597 , 14.03440397686128
2
2,  6.84296274925732 , -34.40717670689995
2,  2.81436321039149 , 16.93461134095244
2
2,  4.63137151920054 , 8.42650749374809
2,  2.51826354979973 , -28.03312243523867
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Lu_ccsd=-40.06565056
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 12
symm = 1
ss= 0

!There are irrep cards paramters
A1=4
B1=1
B2=1
A2=0


geometry={
    2
    LuH molecule
    Lu 0.0 0.0 0.0
    H 0.0 0.0 1.40
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
bind=ccsd-Lu_ccsd-H_ccsd


table,1.40,scf,ccsd,bind
save
type,csv


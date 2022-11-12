***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
4
1, 14.43853095237260,  15.0
3, 13.70143588935427,  216.577964285589000
2, 3.28549604889306 , -5.49901994436885
2, 4.18919552256709 , -6.70104634073794
2
2, 12.10375736803952,  471.14755375368770
2, 3.41886432084825 , 15.23736477202774
2
2, 9.38164223025465 , 265.34190992064919
2, 5.26002300808552 , 49.14982574026606
2
2, 5.98320962505167 , 108.77975533915463
2, 4.73643064550793 , 33.35407025792746
2
2, 2.22984805639770 , 16.91897415701144
2, 4.13206655702579 , 17.85441030398715
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Re_ccsd=-78.26287960
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 16
symm = 1
ss= 4

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    ReH molecule
    Re 0.0 0.0 0.0
    H 0.0 0.0 1.20
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1-1,B2-1,A2-1
 sym,1,1,1,1,2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Re_ccsd-H_ccsd


table,1.20,scf,ccsd,bind
save
type,csv


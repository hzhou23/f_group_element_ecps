***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
4
1, 14.43856838896161,  15.0
3, 13.70063963221794,  216.578525834424150
2, 3.29448755986563 , -5.49658344993933
2, 4.19578759025400 , -6.69954550748515
2
2, 12.11434273023976,  471.14751693586493
2, 3.40222480581405 , 15.23831203950330
2
2, 9.36921557068957 , 265.34205969356907
2, 5.25038039944097 , 49.15044049714530
2
2, 5.96755183184084 , 108.77998426175050
2, 4.72292506038265 , 33.35459697170005
2
2, 2.22898187263090 , 16.91901443256149
2, 4.13198027481934 , 17.85441627608173
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Re_ccsd=-78.17976634
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
    H 0.0 0.0 2.00
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


table,2.00,scf,ccsd,bind
save
type,csv


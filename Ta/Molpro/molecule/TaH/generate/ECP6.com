***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 9.72977071251832 , 13.0
3, 9.04025305231791 , 126.487019262738160
2, 2.28219792500687 , -0.45936988031577
2, 6.18256528141011 , -9.37898519512449
4
2, 14.40648876085446,  899.78004593830656
4, 10.53949302502502,  1.51297812382423
2, 2.46281742879685 , -0.74728692809665
2, 4.80560319008407 , 11.03700907333499
4
2, 10.01200161024997,  334.61021017859207
4, 8.33437931127020 , 5.49792066023563
2, 3.74287984444098 , 3.37938227432620
2, 7.28096635039259 , 21.41871775905508
4
2, 5.81879520796742 , 110.20331903469437
4, 5.66431599759524 , 0.85608519669606
2, 1.05272337290654 , -0.53337130745784
2, 4.61685015411584 , 16.62468989969337
2
2, 1.99110702064689 , 12.75533125658117
2, 4.29972709599874 , 12.33234481127665
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.48033057
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 14
symm = 1
ss= 4

!There are irrep cards paramters
A1=4
B1=2
B2=2
A2=1


geometry={
    2
    TaH molecule
    Ta 0.0 0.0 0.0
    H 0.0 0.0 length
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
bind=ccsd-Ta_ccsd-H_ccsd


table,length,scf,ccsd,bind
save
type,csv


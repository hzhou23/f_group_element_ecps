***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
4
1, 10.79060361129457,  15.0
3, 8.58824174811057 , 161.859054169418550
2, 3.67723395545069 , -12.15295891341798
2, 3.94795680111359 , -12.16979418822632
2
2, 11.17059061629397,  349.55961709990612
2, 3.26820192603944 , 15.06864089973130
2
2, 8.55033731245932 , 339.73293963850978
2, 5.82193902103292 , 42.30328642665054
2
2, 7.32938673660753 , 110.47431041603257
2, 3.03556110426896 , 20.41803460953421
2
2, 2.41929012999010 , 16.48293846030001
2, 3.59710207077404 , 16.52537206187579
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Re_ccsd=-78.11224915
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
    H 0.0 0.0 1.50
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


table,1.50,scf,ccsd,bind
save
type,csv


***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 12.82539658819463,  13.0
3, 11.70309325467236,  166.730155646530190
2, 5.03082579399285 , -4.66790331635790
2, 2.15721943266161 , -1.62554684483801
2
2, 11.67567705967940,  459.21736879071398
2, 2.70754241296273 , 5.93280127675433
2
2, 8.47901944560844 , 379.80916356608083
2, 9.33899700746909 , 37.09249334000437
2
2, 6.75419267385631 , 108.30421504871508
2, 3.65435850888707 , 21.91373762797083
2
2, 6.81091791316786 , 11.99967767737882
2, 1.59592986373716 , 11.97548909477149
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-56.35601039
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
    H 0.0 0.0 1.10
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


table,1.10,scf,ccsd,bind
save
type,csv


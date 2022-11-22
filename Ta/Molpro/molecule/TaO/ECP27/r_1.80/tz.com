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
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Ta_ccsd=-56.35601039
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 19
symm = 1
ss= 3

!There are irrep cards paramters
A1=4
B1=3
B2=3
A2=1


geometry={
    2
    TaH molecule
    Ta 0.0 0.0 0.0
    O 0.0 0.0 1.80
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2-1,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Ta_ccsd-O_ccsd


table,1.80,scf,ccsd,bind
save
type,csv


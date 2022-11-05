***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,ta,60,4;
4
1, 9.47593761498186 , 13.0
3, 6.68419469949979 , 123.187188994764180
2, 4.50279312969118 , -4.74450234479249
2, 5.30655820226264 , -7.50997700647287
4
2, 12.99704809105003,  254.44117827407013
4, 5.17136860328960 , 3.15492505348126
2, 2.45054847249734 , -2.97872515159949
2, 4.39704012056821 , 14.21049728428657
4
2, 10.84432505693473,  292.80358582740024
4, 8.95279612414518 , 11.07748307320084
2, 5.04909650824264 , -2.00408417489747
2, 5.33703107877786 , 12.10072941513010
4
2, 7.38065142842785 , 115.53299868389350
4, 5.88115958446283 , 1.27610040380508
2, 1.64547534200050 , 0.10554873080558
2, 4.60666591597648 , 12.40495137317063
2
2, 4.26313530385666 , 13.45945710075015
2, 2.18936895331619 , 13.01295858377072
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.24974087
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
    H 0.0 0.0 1.80
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


table,1.80,scf,ccsd,bind
save
type,csv


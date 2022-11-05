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


Ta_ccsd=-57.24974087
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
    O 0.0 0.0 1.40
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


table,1.40,scf,ccsd,bind
save
type,csv


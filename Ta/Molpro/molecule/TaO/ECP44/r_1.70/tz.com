***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 7.33443177733808 , 13.0
3, 9.71757435331864 , 95.347613105395040
2, 9.51350089152299 , -0.32384053030616
2, 1.02496833567370 , -0.32012490977607
4
2, 14.63435972541884,  355.04318756605238
4, 6.87015783738479 , -2.74998800080418
2, 8.58234570787466 , 23.42157796064991
2, 5.43562273337292 , 24.77347743794243
4
2, 10.05271468284698,  290.75148331430199
4, 11.20185826698038,  -11.34246159786968
2, 4.23576644325000 , -0.03933469194769
2, 3.04173328136949 , 5.84602514420940
4
2, 5.91505974651468 , 120.30042050468550
4, 3.40826061855330 , -6.82770773408640
2, 4.01110158619859 , 7.58434972086854
2, 5.89308520493976 , 16.61999819794593
2
2, 1.88276693833787 , 13.83995611471672
2, 5.12359135990143 , 12.85436403353524
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


Ta_ccsd=-57.32042609
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
    O 0.0 0.0 1.70
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


table,1.70,scf,ccsd,bind
save
type,csv


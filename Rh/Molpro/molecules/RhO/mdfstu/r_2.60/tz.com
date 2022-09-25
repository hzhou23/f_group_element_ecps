***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,Rh,28,4;
1; 2,1.000000,0.000000;
2; 2,12.194816,225.312054; 2,5.405137,32.441582;
4; 2,11.280755,52.872826; 2,10.927248,105.745526; 2,5.090117,8.619344; 2,4.851832,16.973459;
4; 2,9.136337,25.108501; 2,8.964808,37.695731; 2,3.643612,4.202584; 2,3.636007,6.292790;
2; 2,8.616228,-9.673568; 2,8.629435,-12.899847;
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/Rh-aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Rh_ccsd=-110.04904318
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 23
symm = 1
ss= 3

!There are irrep cards paramters
A1=6
B1=3
B2=3
A2=1


geometry={
    2
    RhO molecule
    Rh 0.0 0.0 0.0
    O 0.0 0.0 2.60
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
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Rh_ccsd-O_ccsd


table,2.60,scf,ccsd,bind
save
type,csv


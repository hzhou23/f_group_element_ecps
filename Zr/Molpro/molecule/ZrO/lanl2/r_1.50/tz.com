***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, zr, 28, 3 ;
5; !  ul potential
0,645.9321873,-0.0425843;
1,134.7547401,-20.2222409;
2,42.3074619,-101.8695172;
2,12.0003227,-41.6195784;
2,4.1260454,-4.6986160;
3; !  s-ul potential
0,117.6251862,2.7910559;
1,22.9646089,41.9489459;
2,4.5225298,67.7271866;
4; !  p-ul potential
0,47.1953145,4.9911144;
1,48.0356033,20.7193172;
2,19.4541456,195.5867758;
2,4.0512875,48.2877176;
5; !  d-ul potential
0,79.9073983,3.0049226;
1,45.8263798,25.9377989;
2,26.9903522,125.1244934;
2,9.6835718,70.7634022;
2,2.7995666,15.0492822;
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/Zr-aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Zr_ccsd=-46.40001722
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 18
symm = 1
ss= 0

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=0


geometry={
    2
    Zr molecule
    Zr 0.0 0.0 0.0
    O 0.0 0.0 1.50
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Zr_ccsd-O_ccsd


table,1.50,scf,ccsd,bind
save
type,csv


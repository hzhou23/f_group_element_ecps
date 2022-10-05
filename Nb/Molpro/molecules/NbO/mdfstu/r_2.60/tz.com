***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,Nb,28,4,0;
1; 2,1.000000,0.000000;
2; 2,9.376578,165.156736; 2,4.043572,21.823951;
4; 2,8.363609,37.249284; 2,8.166898,74.507389; 2,3.693075,5.439486; 2,3.551047,10.913252;
4; 2,6.689108,15.214549; 2,6.537193,22.833508; 2,2.551118,3.000052; 2,2.567896,4.553734;
2; 2,5.568285,-6.281354; 2,5.671372,-8.755644;
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/Nb-aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Nb_ccsd=-56.59124518
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
    YH molecule
    Nb 0.0 0.0 0.0
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
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Nb_ccsd-O_ccsd


table,2.60,scf,ccsd,bind
save
type,csv


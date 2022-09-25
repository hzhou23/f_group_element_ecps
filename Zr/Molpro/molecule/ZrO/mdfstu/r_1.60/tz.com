***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,Zr,28,4,0;
1; 2,1.000000,0.000000;
2; 2,8.636528,150.242994; 2,3.717639,18.780036;
4; 2,7.626728,33.192791; 2,7.453207,66.389039; 2,3.358389,4.620726; 2,3.229738,9.260270;
4; 2,5.938086,13.993383; 2,5.825544,20.995882; 2,2.205019,2.285166; 2,2.206292,3.441260;
2; 2,4.800215,-5.239320; 2,4.798992,-6.987424;
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


Zr_ccsd=-46.69636260
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
    ZrO molecule
    Zr 0.0 0.0 0.0
    O 0.0 0.0 1.60
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


table,1.60,scf,ccsd,bind
save
type,csv


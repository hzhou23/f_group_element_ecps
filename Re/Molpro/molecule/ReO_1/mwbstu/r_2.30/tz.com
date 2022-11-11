***,Calculation for Re atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,Re,60,5,0;
1; 2,1.000000,0.000000;
2; 2,14.099305,1038.951572; 2,7.049653,29.561738;
2; 2,10.107717,339.543510; 2,5.053858,24.913696;
2; 2,6.848618,111.699653; 2,3.424309,12.624329;
1; 2,2.508651,16.449852;
1; 2,3.901245,-16.501120;
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


Re_ccsd=-77.94999046
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 21
symm = 1
ss= 1

!There are irrep cards paramters
A1=6
B1=2
B2=2
A2=1


geometry={
    2
    ReO molecule
    Re 0.0 0.0 0.0
    O 0.0 0.0 2.30
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Re_ccsd-O_ccsd


table,2.30,scf,ccsd,bind
save
type,csv


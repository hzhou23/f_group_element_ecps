***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-12


basis={
ECP,Y,28,4,0;
1; 2,1.000000,0.0000000;
2; 2,7.488049,135.153844; 2,3.744025,15.552441;
2; 2,6.445377,87.784992; 2,3.222689,11.564066;
2; 2,4.658447,29.701001; 2,2.329224,5.539968;
2; 2,6.584212,-19.122198; 2,3.292106,-2.436375;
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/Y-aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Y_ccsd=-38.16360040
O_ccsd=-15.85572648

!These are the wf cards parameters
ne = 17
symm = 1
ss=1

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=0


geometry={
    2
    YO molecule
    Y 0.0 0.0 0.0
    O 0.0 0.0 length
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
bind=ccsd-Y_ccsd-O_ccsd


table,length,scf,ccsd,bind
save
type,csv


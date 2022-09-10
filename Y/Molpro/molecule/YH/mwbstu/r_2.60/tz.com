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
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Y-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Y_ccsd=-38.16360040
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 12
symm = 1
ss= 0

!There are irrep cards paramters
A1=4
B1=1
B2=1
A2=0


geometry={
    2
    YH molecule
    Y 0.0 0.0 0.0
    H 0.0 0.0 2.60
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
bind=ccsd-Y_ccsd-H_ccsd


table,2.60,scf,ccsd,bind
save
type,csv


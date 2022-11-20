***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
4
1, 13.99291119644726,  15.0
3, 13.16490622126587,  209.893667946708900
2, 3.87331571280797 , -8.07685208267677
2, 3.65422647445502 , -9.99969366723489
2
2, 11.52741505871857,  471.04055986421770
2, 3.52193891828695 , 17.80888746509934
2
2, 9.67053377874090 , 265.26931814718881
2, 4.69321362788258 , 48.51541788146839
2
2, 6.20260651177507 , 107.92097886520729
2, 4.05488298460774 , 31.43796943420103
2
2, 2.50292205999714 , 16.90564448518640
2, 4.01397593729297 , 17.85814208198506
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Re_ccsd=-78.26177899 
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 16
symm = 1
ss= 4

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    ReH molecule
    Re 0.0 0.0 0.0
    H 0.0 0.0 1.30
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
bind=ccsd-Re_ccsd-H_ccsd


table,1.30,scf,ccsd,bind
save
type,csv


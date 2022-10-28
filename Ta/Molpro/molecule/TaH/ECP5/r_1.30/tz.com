***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 9.96102142251623 , 13.0
3, 8.66753180821403 , 129.493278492710990
2, 3.18293734710823 , -6.44289441991725
2, 3.37444446594210 , -7.85803706449262
4
2, 11.76280919071458,  454.58924740165031
4, 10.54478300852329,  2.83798725639408
2, 2.20845245478701 , -1.27159179030538
2, 3.04787065946180 , 12.78948851428200
4
2, 9.16823157907189 , 292.69323167970038
4, 8.55157810162544 , 11.09449423855064
2, 2.84461656319272 , -0.82798881088714
2, 3.11834655778119 , 12.56777196647712
4
2, 5.40674277680677 , 115.65450592465247
4, 5.81188044539469 , 1.23403492783475
2, 1.38012716297445 , -1.28569069037775
2, 3.16698480959398 , 12.76813670988949
2
2, 2.05979276202828 , 13.46298142736888
2, 2.88241373632644 , 12.94572104718611
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.47859734
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 14
symm = 1
ss= 4

!There are irrep cards paramters
A1=4
B1=2
B2=2
A2=1


geometry={
    2
    TaH molecule
    Ta 0.0 0.0 0.0
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
bind=ccsd-Ta_ccsd-H_ccsd


table,1.30,scf,ccsd,bind
save
type,csv


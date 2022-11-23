***,Calculation for GdH3 atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Gd, 46, 4 ;
4
1, 4.64649423380707,  18.0
3, 5.03898469561614,  83.636896208527260
2, 6.14922726155977,  -94.54346463109100
2, 5.39086597594697,  -9.07764978300212
2
2, 9.64508287717261,  160.08091893942253
2, 4.89569161141406,  82.16244181564230
2
2, 7.84634259934576,  88.42449114602753
2, 3.73740426162130,  54.36568213794933
2
2, 9.87079385121206,  55.57793911614991
2, 2.47059638061654,  31.33022231606614
2
2, 3.70555603254771,  -25.69937903186067
2, 6.16350930047429,  -4.52646585527923
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Gd_ccsd=-109.2993715
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 21
symm = 4
ss= 7

!There are irrep cards paramters
A1=7
B1=3
B2=3
A2=1

angstrom
geometry={
    Gd
    H1 Gd length
    H2 Gd length H1 120
    H3 Gd length H1 120 H2 180
}
basis={
include,../../generate/contracted.basis
include,../../generate/H-aug-cc-pVTZ.basis
}
{rks,pbe0
 start,atden
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-2,B2-2,A2-1
 print,orbitals=2
 orbital,2202.2
}
{rhf,nitord=60;
 start,2202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-2,B2-2,A2-1
 print,orbitals=2
 orbital,3202.2
}
basis={
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}
{rhf,nitord=60;
 start,3202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-2,B2-2,A2-1
 print,orbitals=2
}

scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Gd_ccsd-H_ccsd-H_ccsd-H_ccsd

table,length,scf,ccsd,bind
save
type,csv


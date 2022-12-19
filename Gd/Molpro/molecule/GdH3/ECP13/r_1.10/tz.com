***,Calculation for GdH3 atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Gd, 46, 4 ;
4
1 4.00344854305685    18.0
3 3.60717766063765    72.062073775
2 5.21365732868997    -88.86831938358846
2 2.18770217170469    -10.30689532343296
2
2 15.19768280892150   160.78757267405976
2 4.22792214772802    68.05296264192927
2
2 11.34094238963603   85.69251202359456
2 3.71806799706924    59.15826995409884
2
2 8.48307462992686    54.83878483316050
2 2.34176280592863    26.51295055167017
2
2 3.25436714839169    -20.21715516815462
2 2.89616097318773    -0.00105879986854
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Gd_ccsd=-109.0700892
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 21
symm = 1
ss= 5

!There are irrep cards paramters
A1=6
B1=3
B2=3
A2=1

angstrom
geometry={
    Gd
    H1 Gd 1.10
    H2 Gd 1.10 H1 120
    H3 Gd 1.10 H1 120 H2 180
}
{rks,pbe0,maxdis=30,nitord=50;
 start,atden
 maxit,200;
 shift,-2.0,-1.0
 wf,ne-1,symm,ss-1
 occ,A1-1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 print,orbitals=2
 orbital,2202.2
}
{rhf,nitord=60;
 start,2202.2
 maxit,200;
 wf,ne-1,symm,ss-1
 occ,A1-1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 print,orbitals=2
 orbital,3202.2
}
{rks,pbe0,maxdis=30,nitord=50;
 start,3202.2
 maxit,200;
 shift,-2.0,-1.0
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 print,orbitals=2
 orbital,4202.2
}
{rhf,nitord=60;
 start,4202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 print,orbitals=2
}

scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Gd_ccsd-H_ccsd-H_ccsd-H_ccsd

table,1.10,scf,ccsd,bind
save
type,csv


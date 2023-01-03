***,Calculation for GdH3 atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Gd, 46, 4 ;
4
1,  4.482334567,  18
3,  4.564889708,  82.168014744
2,  5.66712002 , -92.9838255305621
2,  3.16146066 , -4.5706186489810925
2
2,  11.95874295,  158.74380701879028
2,  4.57502029 , 75.24558611007733
2
2,  9.32702741 , 85.27718849776822
2,  3.72730927 , 55.169023412731704
2
2,  9.14239802 , 55.34157036482078
2,  2.41026285 , 27.58623059967926
2
2,  3.49609108 , -24.953301558714806
2,  6.1622991  ,-2.8384856422783815
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Gd_ccsd=-108.9485971
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
    H1 Gd 1.60
    H2 Gd 1.60 H1 120
    H3 Gd 1.60 H1 120 H2 180
}
{rks,pbe0,maxdis=30,nitord=50;
 start,atden
 maxit,200;
 shift,-2.0,-1.0
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-2,B2-2,A2-1
 print,orbitals=2
 orbital,4202.2
}
{multi
 occ,A1,B1,B2,A2
 closed,A1-2,B1-2,B2-2,A2-1
 wf,ne,symm,ss;state,1;
 natorb,ci,print
 orbital,5202.2
}
{rhf, maxit=0, nitord=1;
 start,5202.2
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

table,1.60,scf,ccsd,bind
save
type,csv


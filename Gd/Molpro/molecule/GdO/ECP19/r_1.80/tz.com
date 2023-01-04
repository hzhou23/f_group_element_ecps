***,Calculation for GdO, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Gd, 46, 4 ;
4
1,  4.482334567,  18
3,  4.564889708,  82.168014744
2,  5.66712002 , -92.93860739964789
2,  3.16146066 , -4.602408419618977
2
2,  11.95874295,  158.64506379643842
2,  4.57502029 , 75.26520432683748
2
2,  9.32702741 , 85.45657782727788
2,  3.72730927 , 55.07374484251613
2
2,  9.14239802 , 55.258780373666305
2,  2.41026285 , 27.66555204018456
2
2,  3.49609108 , -24.943858338204326
2,  6.1622991  ,-2.9362910549789754
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


Gd_ccsd=-109.02453288
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 24
symm = 4
ss= 8

!There are irrep cards paramters
A1=7
B1=4
B2=4
A2=1


geometry={
    2
    GdO molecule
    Gd 0.0 0.0 0.0
    O 0.0 0.0 1.80
}
{rks,pbe0,maxdis=30,nitord=50;
 start,atden
 maxit,200;
 wf,ne-1,symm,ss-1
 occ,A1-1,B1,B2,A2
 closed,A1-3,B1-2,B2-2,A2-1
 print,orbitals=2
 orbital,2202.2
}
{rhf,nitord=60;
 start,2202.2
 maxit,200;
 wf,ne-1,symm,ss-1
 occ,A1-1,B1,B2,A2
 closed,A1-3,B1-2,B2-2,A2-1
 print,orbitals=2
 orbital,3202.2
}
{rks,pbe0,maxdis=30,nitord=50;
 start,3202.2
 maxit,200;
 shift,-2.0,-1.0
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-3,B1-2,B2-2,A2-1
 print,orbitals=2
 orbital,4202.2
}
{rhf,nitord=60;
 start,4202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-3,B1-2,B2-2,A2-1
 print,orbitals=2
 orbital,5202.2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Gd_ccsd-O_ccsd


table,1.80,scf,ccsd,bind
save
type,csv


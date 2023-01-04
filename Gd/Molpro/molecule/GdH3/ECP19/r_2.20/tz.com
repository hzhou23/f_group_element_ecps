***,Calculation for GdH3 atom, singlet and triplet
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
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Gd_ccsd=-109.02453288
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 21
symm = 4
ss= 7

!There are irrep cards paramters
A1=6
B1=4
B2=3
A2=1

angstrom
geometry={
    Gd
    H1 Gd 2.20
    H2 Gd 2.20 H1 120
    H3 Gd 2.20 H1 120 H2 180
}
{multi
 start,atden
 occ,A1,B1,B2,A2
 closed,A1-2,B1-2,B2-2,A2-1
 wf,ne,symm,ss;state,1;
 natorb,ci,print
 orbital,5202.2
}
{rhf, maxit=100, nitord=60;
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

table,2.20,scf,ccsd,bind
save
type,csv


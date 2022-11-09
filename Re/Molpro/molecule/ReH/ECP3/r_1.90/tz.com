***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
4
1, 9.20761727233161 , 15.0
3, 8.69674131900234 , 138.114259084974150
2, 3.01319002821308 , -10.16399504874812
2, 4.66575497930990 , -7.75988144056642
2
2, 12.63238372032797,  349.65442121292870
2, 3.40122154203331 , 19.65831124498570
2
2, 9.81696143671290 , 339.58091274682283
2, 4.81024776045297 , 41.06872099172463
2
2, 7.32408280109972 , 111.58580911493202
2, 3.41848195993421 , 27.15043241463062
2
2, 2.19500650073756 , 16.47982301672791
2, 3.70845189248067 , 16.51475535748299
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Re_ccsd=-78.12395706
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
    H 0.0 0.0 1.90
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


table,1.90,scf,ccsd,bind
save
type,csv


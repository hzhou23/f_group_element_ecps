***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, zr, 28, 3 ;
1; !  ul potential
1,4.3144100,-6.1192300;
3; !  s-ul potential
0,0.9303500,4.5703100;
2,2.3300300,-112.5585400;
2,2.6663200,139.0297200;
3; !  p-ul potential
0,0.9775300,4.0452400;
2,2.1499800,-66.6476800;
2,2.5089200,86.3703400;
2; !  d-ul potential
0,16.5759800,5.6408500;
2,3.3207900,26.6609300;
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Zr-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Zr_ccsd=-46.72916065
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 13
symm = 2
ss= 1

!There are irrep cards paramters
A1=4
B1=2
B2=1
A2=0


geometry={
    2
    YH molecule
    Zr 0.0 0.0 0.0
    H 0.0 0.0 length
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Zr_ccsd-H_ccsd


table,length,scf,ccsd,bind
save
type,csv


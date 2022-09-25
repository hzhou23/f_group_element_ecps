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
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/Zr-aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pVTZ.basis
}


Zr_ccsd=-46.72916065
O_ccsd=-15.85572648

!These are the wf cards parameters
ne = 18
symm = 1
ss= 0

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=0


geometry={
    2
    ZrO molecule
    Zr 0.0 0.0 0.0
    O 0.0 0.0 2.20
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
bind=ccsd-Zr_ccsd-O_ccsd


table,2.20,scf,ccsd,bind
save
type,csv


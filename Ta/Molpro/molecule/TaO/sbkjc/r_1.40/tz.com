***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
1; !  ul potential
1,1.6526200,-4.3344000;
3; !  s-ul potential
0,3.7845000,4.2402200;
2,3.1783800,-30.3823100;
2,3.9505800,89.3281100;
3; !  p-ul potential
0,1.0058000,3.3386800;
2,2.3539000,-138.0217300;
2,2.5819100,171.5334900;
2; !  d-ul potential
0,24.2912900,3.0491300;
2,3.1860400,41.2051500;
1; !  f-ul potential
0,1.1301100,7.8463400;
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


Ta_ccsd=-57.46009777
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 19
symm = 1
ss= 3

!There are irrep cards paramters
A1=4
B1=3
B2=3
A2=1


geometry={
    2
    TaO molecule
    Ta 0.0 0.0 0.0
    O 0.0 0.0 1.40
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2-1,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Ta_ccsd-O_ccsd


table,1.40,scf,ccsd,bind
save
type,csv


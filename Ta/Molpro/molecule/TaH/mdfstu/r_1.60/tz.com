***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,Ta,60,5,0;
1; 2,1.000000,0.000000;
3; 2,10.318069,454.600649; 4,10.540267,2.837975; 2,2.574726,-0.814736;
6; 2,8.743342,96.910783; 2,7.916223,195.850432; 4,9.275736,4.812524; 4,8.101675,6.338512; 2,2.077127,-0.459173; 2,2.750372,-0.644586;
6; 2,5.447314,45.969976; 2,5.212545,69.638972; 4,5.884358,0.802933; 4,5.649579,0.429595; 2,1.388180,-0.307227; 2,1.294398,-0.461560;
2; 2,2.161275,5.757773; 2,2.125939,7.678167;
2; 2,3.145920,-5.684066; 2,3.127942,-7.062313;
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.14841446
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
    H 0.0 0.0 1.60
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


table,1.60,scf,ccsd,bind
save
type,csv


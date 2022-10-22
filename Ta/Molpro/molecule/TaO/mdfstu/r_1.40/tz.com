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


Ta_ccsd=-57.14841446
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 19
symm = 1
ss= 1

!There are irrep cards paramters
A1=5
B1=2
B2=2
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
 closed,A1-1,B1,B2,A2
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


***,Calculation for Ta atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Ta
Ta  0.0 0.0 0.0
}

basis={
ECP,Ta,60,5,0;
1; 2,1.000000,0.000000; 
3; 2,10.318069,454.600649; 4,10.540267,2.837975; 2,2.574726,-0.814736; 
6; 2,8.743342,96.910783; 2,7.916223,195.850432; 4,9.275736,4.812524; 4,8.101675,6.338512; 2,2.077127,-0.459173; 2,2.750372,-0.644586; 
6; 2,5.447314,45.969976; 2,5.212545,69.638972; 4,5.884358,0.802933; 4,5.649579,0.429595; 2,1.388180,-0.307227; 2,1.294398,-0.461560; 
2; 2,2.161275,5.757773; 2,2.125939,7.678167; 
2; 2,3.145920,-5.684066; 2,3.127942,-7.062313; 
include,../../generate/aug-cc-pwCVTZ.basis
}




{rhf
 start,atden
 print,orbitals=2
 wf,13,4,3
 occ,3,1,1,0,1,1,1,0
 closed,2,1,1,0,1,0,0,0
 sym,1,1,1,3,2
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,4,1,1,1,1,1,1,0
 closed,2,1,1,0,1,0,0,0
 wf,13,4,3;state,3
 wf,13,6,3;state,3
 wf,13,7,3;state,3
 wf,13,1,3;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,13,4,3
 occ,3,1,1,0,1,1,1,0
 closed,2,1,1,0,1,0,0,0
}
scf(i)=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,100;core}
ccsd(i)=energy

table,scf,ccsd
type,csv
save

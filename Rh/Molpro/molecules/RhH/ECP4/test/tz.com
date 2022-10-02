***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, rh, 28, 3,
4
1, 24.35954556943091, 17.0
3, 22.40769963113739, 414.112274680325470
2, 8.82566781758089 ,-11.36083129504946
2, 9.42640291894711 ,-13.71529797905121
2
2, 12.44034508554911, 246.88451553896567
2, 5.11891222177659 ,32.37294700248441
2
2, 9.52131743809516 ,181.14052359801886
2, 6.59862060819446 ,29.12634941339750
2
2, 9.22481344680887 ,83.10232015905464
2, 3.72212743230288 ,10.95146553384096
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Rh-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 18
symm = 1
ss= 2

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    RhH molecule
    Rh 0.0 0.0 0.0
    H 0.0 0.0 1.60
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy

geometry={
    1
    Rh atom	
    Rh 0.0 0.0 0.0
}
{rhf
 start,atden
 print,orbitals=2
 wf,17,1,3
 occ,4,1,1,1,1,1,1,0
 closed,1,1,1,1,1,1,1,0
 sym,1,1,1,3,2
 restrict,1,1,2.1
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,4,1,1,1,1,1,1,0
 closed,1,1,1,0,1,0,0,0
 wf,17,4,3;state,3
 restrict,1,1,2.1
 wf,17,6,3;state,3
 restrict,1,1,2.1
 wf,17,7,3;state,3
 restrict,1,1,2.1
 wf,17,1,3;state,1
 restrict,1,1,2.1
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,17,1,3
 occ,4,1,1,1,1,1,1,0
 closed,1,1,1,1,1,1,1,0
 sym,1,1,1,3,2
 restrict,1,1,2.1
}
Rh_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;core}
Rh_ccsd=energy

bind=ccsd-Rh_ccsd-H_ccsd


table,1.60,scf,ccsd,bind
save
type,csv


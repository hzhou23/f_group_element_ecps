***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, rh, 28, 3
4
1, 23.94017368403376,  17.0
3, 25.74311879663761,  406.982952628573920
2, 9.96274124399403 , -12.61424715702161
2, 7.79473247706902 , -15.02753324949004
2
2, 12.14518225062157,  246.99971288623982
2, 5.13144177437856 , 33.21734893624698
2
2, 10.46673502585171,  180.02274296232602
2, 4.97733342125984 , 25.35976855059384
2
2, 8.85022709974022 , 83.20600184199769
2, 3.98140097511640 , 12.45806846546400
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


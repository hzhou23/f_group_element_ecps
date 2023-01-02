***,Calculation for GdH3 atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../generate/H-aug-cc-pVTZ.basis
}



!These are the wf cards parameters

!There are irrep cards paramters

angstrom
geometry={
    H 0.0 0.0 0.0
}
{rhf,nitord=60;
 start,atden
 maxit,200;
 wf,1,1,1
 occ,1,0,0,0,0,0,0,0
 closed,0,0,0,0,0,0,0,0
 print,orbitals=2
}

scf=energy
_CC_NORM_MAX=2.0
{rccsd(t)}
ccsd=energy

table,scf,ccsd
save
type,csv


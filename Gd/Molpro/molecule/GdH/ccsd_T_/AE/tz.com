***,Calculation for all-electron GdH3 molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/aug-cc-pwCVTZ.basis
include,../generate/H-aug-cc-pVTZ.basis
}

Gd_ccsd=-11270.57462733
H_ccsd=-0.49982785

!These are the wf cards parameters
ne = 65
symm = 4
ss= 7


!There are irrep cards paramters
A1=17
B1=8
B2=8
A2=3

angstrom
geometry={
    2
    GdH molecule
    Gd 0.0 0.0 0.0
    H 0.0 0.0 2.10
}
basis={
include,../generate/contracted.basis
include,../generate/H-aug-cc-pVTZ.basis
}
{rhf,nitord=60;
 start,atden
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-2,B2-2,A2-1
 print,orbitals=2
 orbital,3202.2
}
basis={
include,../generate/aug-cc-pwCVTZ.basis
include,../generate/H-aug-cc-pVTZ.basis
}
{rhf,nitord=60;
 start,3202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-2,B2-2,A2-1
 print,orbitals=2
}

scf=energy
_CC_NORM_MAX=2.0
{rccsd[T],shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Gd_ccsd-H_ccsd


table,2.10,scf,ccsd,bind
save
type,csv


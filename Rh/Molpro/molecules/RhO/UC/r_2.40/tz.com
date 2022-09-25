***,Calculation for all-electron YH molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/Rh-aug-cc-pwCVTZ.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}

Rh_ccsd=-4781.905747
O_ccsd=-75.03694110
  
!These are the wf cards parameters
ne = 53
symm = 1
ss= 3

!There are irrep cards paramters
A1=14
B1=6
B2=6
A2=2


geometry={
    2
    RhO molecule
    Rh 0.0 0.0 0.0
    O 0.0 0.0 2.40
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
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core,8,3,3,1}
ccsd=energy
bind=ccsd-Rh_ccsd-O_ccsd


table,2.40,scf,ccsd,bind
save
type,csv


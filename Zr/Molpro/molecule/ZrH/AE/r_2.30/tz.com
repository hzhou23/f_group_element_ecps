***,Calculation for all-electron YH molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/Zr-aug-cc-pwCVTZ.basis
include,../generate/H-aug-cc-pVTZ.basis
}

Zr_ccsd=-3597.393660
H_ccsd=-0.49982785
  
!These are the wf cards parameters
ne = 41
symm = 2
ss= 1

!There are irrep cards paramters
A1=11
B1=5
B2=4
A2=1


geometry={
    2
    ZrH molecule
    Zr 0.0 0.0 0.0
    H 0.0 0.0 2.30
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Zr_ccsd-H_ccsd


table,2.30,scf,ccsd,bind
save
type,csv


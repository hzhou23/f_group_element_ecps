***,Calculation for all-electron YH molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/Y-aug-cc-pwCVTZ.basis
include,../generate/H-aug-cc-pVTZ.basis
}

Y_ccsd=-3384.082171
H_ccsd=-0.49982785
  
!These are the wf cards parameters
ne = 40
symm = 1
ss= 0

!There are irrep cards paramters
A1=11
B1=4
B2=4
A2=1


geometry={
    2
    YH molecule
    Y 0.0 0.0 0.0
    H 0.0 0.0 2.40
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Y_ccsd-H_ccsd


table,2.40,scf,ccsd,bind
save
type,csv


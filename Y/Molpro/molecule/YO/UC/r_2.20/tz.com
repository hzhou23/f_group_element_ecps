***,Calculation for all-electron YH molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-12

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/Y-aug-cc-pwCVTZ.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}

Y_ccsd=-3383.299108
O_ccsd=-75.03694110
  
!These are the wf cards parameters
ne = 47
symm = 1
ss= 1

!There are irrep cards paramters
A1=13
B1=5
B2=5
A2=1


geometry={
    2
    YO molecule
    Y 0.0 0.0 0.0
    O 0.0 0.0 2.20
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
{rccsd(t);maxit,100;core,8,3,3,1}
ccsd=energy
bind=ccsd-Y_ccsd-O_ccsd


table,2.20,scf,ccsd,bind
save
type,csv


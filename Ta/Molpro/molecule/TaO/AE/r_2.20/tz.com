***,Calculation for all-electron YH molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/aug-cc-pwCVTZ.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}

Ta_ccsd=-15604.88640
O_ccsd=-75.09173839
  
!These are the wf cards parameters
ne = 81
symm = 1
ss= 1

!There are irrep cards paramters
A1=19
B1=9
B2=9
A2=4


geometry={
    2
    TaO molecule
    Ta 0.0 0.0 0.0
    O 0.0 0.0 2.20
}
basis={
include,../generate/new_contracted.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 orbital,2202.2
}
basis={
include,../generate/aug-cc-pwCVTZ.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}
{rhf,nitord=20;
 start,2202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Ta_ccsd-O_ccsd


table,2.20,scf,ccsd,bind
save
type,csv


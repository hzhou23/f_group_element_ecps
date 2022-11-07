***,Calculation for all-electron ReO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/aug-cc-pwCVTZ.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}

Re_ccsd=-16691.05054145
O_ccsd=-75.03694110
  
!These are the wf cards parameters
ne = 83
symm = 1
ss= 5

!There are irrep cards paramters
A1=20
B1=10
B2=10
A2=4


geometry={
    2
    ReO molecule
    Re 0.0 0.0 0.0
    O 0.0 0.0 2.60
}
basis={
include,../generate/new_contracted.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
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
 closed,A1-2,B1-1,B2-1,A2-1
 orbital,3202.2
 print,orbitals=2
}
{rhf,nitord=1,maxit=0;
 start,3202.2
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 rotate,13.1,15.1,0
 orbital,4202.2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core,14,7,7,3}
ccsd=energy
bind=ccsd-Re_ccsd-O_ccsd


table,2.60,scf,ccsd,bind
save
type,csv


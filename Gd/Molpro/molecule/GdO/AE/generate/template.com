***,Calculation for all-electron GdO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/aug-cc-pwCVTZ.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}

Gd_ccsd=-11270.57462733
O_ccsd=-75.09173839
  
!These are the wf cards parameters
ne = 72
symm = 4
ss= 8

!There are irrep cards paramters
A1=19
B1=9
B2=9
A2=3

angstrom
geometry={
    2
    GdO molecule
    Gd 0.0 0.0 0.0
    O 0.0 0.0 length
}
basis={
include,../generate/contracted.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}
{rks,pbe0
 start,atden
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-3,B1-2,B2-2,A2-1
 orbital,2202.2
 print,orbitals=2
}
{rhf,nitord=60;
 start,2202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-3,B1-2,B2-2,A2-1
 print,orbitals=2
 orbital,3202.2
}
basis={
include,../generate/aug-cc-pwCVTZ.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}
{rhf,nitord=60;
 start,3202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-3,B1-2,B2-2,A2-1
 print,orbitals=2
 orbital,4202.2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Gd_ccsd-O_ccsd


table,length,scf,ccsd,bind
save
type,csv


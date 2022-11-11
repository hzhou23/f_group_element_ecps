***,Calculation for all-electron ReO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/aug-cc-pwCVTZ.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}

geometry={
    1
    Re atom change core
    Re 0.0 0.0 0.0
}
basis={
include,../generate/new_contracted.basis
}
{rks,pbe0
 start,atden
 print,orbitals=2
 wf,75,1,5
 occ,12,6,6,3,6,3,3,1
 closed,10,6,6,2,6,2,2,1
 sym,1,1,1,1,3,2,1,3,2,1,1,3,2
 orbital,3202.2
}
{rhf
 start,3202.2
 print,orbitals=2
 wf,75,1,5
 occ,12,6,6,3,6,3,3,1
 closed,10,6,6,2,6,2,2,1
 sym,1,1,1,1,3,2,1,3,2,1,1,3,2
 orbital,4202.2
}
{multi
 start,4202.2
 occ,12,6,6,3,6,3,3,1
 closed,10,6,6,2,6,2,2,1
 wf,75,1,5;state,1
 natorb,ci,print
 orbital,5202.2
}
pop
basis={
include,../generate/aug-cc-pwCVTZ.basis
}
{multi
 start,5202.2
 occ,12,6,6,3,6,3,3,1
 closed,10,6,6,2,6,2,2,1
 wf,75,1,5;state,1
 natorb,ci,print
 orbital,6202.2
}
{rhf,nitord=1,maxit=0
 start,6202.2
 wf,75,1,5
 occ,12,6,6,3,6,3,3,1
 closed,10,6,6,2,6,2,2,1
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),maxit=100;core,8,5,5,2,3,2,2,1}
Re_ccsd=energy

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
    O 0.0 0.0 1.50
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
 orbital,2302.2
}
basis={
include,../generate/aug-cc-pwCVTZ.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}
{rhf,nitord=20;
 start,2302.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 orbital,3302.2
 print,orbitals=2
}
{rhf,nitord=1,maxit=0;
 start,3302.2
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core,12,7,7,3}
ccsd=energy
bind=ccsd-Re_ccsd-O_ccsd


table,1.50,scf,ccsd,bind
save
type,csv


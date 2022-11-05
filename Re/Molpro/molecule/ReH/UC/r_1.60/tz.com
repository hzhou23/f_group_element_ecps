***,Calculation for all-electron ReH molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/aug-cc-pwCVTZ.basis
include,../generate/H-aug-cc-pVTZ.basis
}

Re_ccsd=-16690.90005569
H_ccsd=-0.49982785
  
!These are the wf cards parameters
ne = 76
symm = 1
ss= 4

!There are irrep cards paramters
A1=18
B1=9
B2=9
A2=4


geometry={
    2
    ReH molecule
    Re 0.0 0.0 0.0
    H 0.0 0.0 1.60
}
basis={
include,../generate/new_contracted.basis
include,../generate/H-aug-cc-pVTZ.basis
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1-1,B2-1,A2-1
 orbital,2202.2
}
basis={
include,../generate/aug-cc-pwCVTZ.basis
include,../generate/H-aug-cc-pVTZ.basis
}
{rhf,nitord=20;
 start,2202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1-1,B2-1,A2-1
 orbital,3202.2
 print,orbitals=2
}
{rhf,nitord=1,maxit=0;
 start,3202.2
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1-1,B2-1,A2-1
 rotate,12.1,14.1,0
 rotate,13.1,15.1,0
 rotate,6.2,8.2,0
 rotate,6.3,8.3,0
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core,13,7,7,3}
ccsd=energy
bind=ccsd-Re_ccsd-H_ccsd


table,1.60,scf,ccsd,bind
save
type,csv


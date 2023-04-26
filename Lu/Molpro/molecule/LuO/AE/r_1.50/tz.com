***,Calculation for all-electron LuO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/messyminus.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}

Lu_ccsd=-14563.50680
O_ccsd=-75.09173839
  
!These are the wf cards parameters
ne = 79
symm = 1
ss= 1

!There are irrep cards paramters
A1=19
B1=9
B2=9
A2=3

angstrom
geometry={
    2
    LuO molecule
    Lu 0.0 0.0 0.0
    O 0.0 0.0 1.50
}
basis={
include,../generate/contracted.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}
{rhf,nitord=60;
 start,atden
 maxit,200;
 wf,ne-1,symm,ss-1
 occ,A1-1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
 orbital,2202.2
}
{rhf,nitord=60;
 start,2202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
 orbital,3202.2
}
basis={
include,../generate/messyminus.basis
include,../generate/O-aug-cc-pwCVTZ.basis
}
{rhf,nitord=60;
 start,3202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
 orbital,4202.2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Lu_ccsd-O_ccsd


table,1.50,scf,ccsd,bind
save
type,csv


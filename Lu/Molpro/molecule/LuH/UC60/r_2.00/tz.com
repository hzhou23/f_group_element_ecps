***,Calculation for all-electron GdH3 molecule, SCF and CCSD(T)
memory,2,g
gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/messyminus.basis
include,../generate/H-aug-cc-pVTZ.basis
}

Lu_ccsd=-14559.96444
H_ccsd=-0.49982785

!These are the wf cards parameters
ne = 72
symm = 1
ss= 0


!There are irrep cards paramters
A1=17                                                         
B1=8
B2=8
A2=3

angstrom
geometry={
    2
    LuH molecule
    Lu 0.0 0.0 0.0
    H 0.0 0.0 2.00
}
basis={
include,../generate/contracted.basis
include,../generate/H-aug-cc-pVTZ.basis
}
{rhf,nitord=60;
 start,atden
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 print,orbitals=2
 orbital,3202.2
}
basis={
include,../generate/messyminus.basis
include,../generate/H-aug-cc-pVTZ.basis
}
{rhf,nitord=60;
 start,3202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 print,orbitals=2
 orbital,4202.2
}
{rhf,nitord=1,maxit=0;
 start,4202.2
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 rotate,12.1,14.1,0
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core,13,7,7,3}
ccsd=energy
bind=ccsd-Lu_ccsd-H_ccsd


table,2.00,scf,ccsd,bind
save
type,csv


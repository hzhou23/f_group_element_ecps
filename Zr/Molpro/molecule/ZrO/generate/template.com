***,Calculation for all-electron YH molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/Y-aug-cc-pwCVTZ.basis
include,../generate/H-aug-cc-pVTZ.basis
}


geometry={
    1
    Y atom
    Y 0.0 0.0 0.0
}
{rhf
 start,atden
 print,orbitals=2
 wf,39,1,1
 occ,8,3,3,1,3,1,1
 closed,7,3,3,1,3,1,1
 sym,1,1,1,1,3,2,1,1,3,2
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,9,3,3,2,3,2,2
 closed,7,3,3,1,3,1,1
 wf,39,1,1;state,2
 wf,39,4,1;state,1
 wf,39,6,1;state,1
 wf,39,7,1;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,39,1,1
 occ,8,3,3,1,3,1,1
 closed,7,3,3,1,3,1,1
 sym,1,1,1,1,3,2,1,1,3,2
}
Y_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
Y_ccsd=energy



geometry={
   1
   Hydrogen
   H 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,1,1,1;
 occ,1,0,0,0,0,0,0,0;
 open,1.1;
}
H_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
H_ccsd=energy


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
    H 0.0 0.0 length
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


table,length,scf,ccsd,bind
save
type,csv


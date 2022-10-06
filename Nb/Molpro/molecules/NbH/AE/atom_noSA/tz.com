***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.0E-15

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/Nb-aug-cc-pwCVTZ.basis
}
geometry={
   1
   Nb
   Nb 0.0 0.0 0.0
}
{rhf
 start,atden
 print,orbitals=2
 wf,41,1,5
 occ,8,3,3,2,3,2,2,0
 closed,6,3,3,1,3,1,1,0
 sym,1,1,1,1,3,2,1,1,3,2
 restrict,1,1,7.1
 orbital,3202.2
}
Nb_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
Nb_ccsd=energy


table,Nb_scf,Nb_ccsd
save
type,csv

***,Calculation for all-electron YH molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=2


basis={
include,O-aug-cc-pwCVTZ.basis
}



geometry={
   1
   Oxygen
   O 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,8,7,2;
 occ,2,1,1,0,1,0,0,0;
 closed,2,1,0,0,0,0,0,0;
}
O_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core,1,0,0,0,0,0,0,0}
O_ccsd=energy


table,1.10,O_ccsd
save
type,csv


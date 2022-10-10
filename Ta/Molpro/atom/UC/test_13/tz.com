***,Calculation for Nb atom, singlet and triplet
memory,2,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

set,dkroll=1,dkho=10,dkhp=4

geometry={
1
Ta
Ta  0.0 0.0 0.0
}

basis={
include,../aug-cc-pwCVTZ.basis
}


{rhf
 start,atden
 print,orbitals=2
 wf,66,7,2
 occ,9,6,6,2,6,2,2,1
 closed,9,6,5,2,5,2,2,1
 sym,2,1,1,1,3,2,1
 sym,3,1,1,1,3,2,1
 sym,5,1,1,1,3,2,1
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,9,6,6,2,6,2,2,1
 closed,9,5,5,2,5,2,2,1
 wf,66,7,2;state,1
 wf,66,6,2;state,1
 wf,66,4,2;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,66,7,2
 occ,9,6,6,2,6,2,2,1
 closed,9,6,5,2,5,2,2,1
}
scf(i)=energy
_CC_NORM_MAX=2.0
{rccsd(t),maxit=100;core,8,5,5,2,5,2,2,1}
ccsd(i)=energy

table,scf,ccsd
type,csv
save
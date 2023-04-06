***,Calculation for Lu atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Lu
Lu  0.0 0.0 0.0
}

basis={
include,../contracted.basis
}
{rhf
 start,atden
 print,orbitals=2
 wf,71,1,1
 occ,11,6,6,2,6,2,2,1
 closed,10,6,6,2,6,2,2,1
 sym,1,1,1,1,3,2,1,3,2,1,1,3,2
 sym,2,1,1,1,1,3,2
 sym,3,1,1,1,1,3,2
 sym,5,1,1,1,1,3,2
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,12,6,6,3,6,3,3,1
 closed,10,6,6,2,6,2,2,1
 wf,71,1,1;state,2
 wf,71,4,1;state,1
 wf,71,6,1;state,1
 wf,71,7,1;state,1
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,71,1,1
 occ,11,6,6,2,6,2,2,1
 closed,10,6,6,2,6,2,2,1
}
scf=energy




table,scf,!ccsd
type,csv
save

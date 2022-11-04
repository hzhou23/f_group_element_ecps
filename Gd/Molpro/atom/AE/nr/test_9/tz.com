***,Calculation for Gd atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Gd
Gd  0.0 0.0 0.0
}

basis={
include,../aug-cc-pwCVTZ.basis
}



include,../Gd_states_ae.proc

{rhf
 start,atden
 print,orbitals=2
 wf,58,1,4
 occ,9,5,5,2,5,2,2,1
 closed,9,4,4,2,4,2,2,0
 sym,1,1,1,1,3,2,1,3,2,1,3,2
 sym,2,1,1,1,1,3,2
 sym,3,1,1,1,1,3,2
 sym,5,1,1,1,1,3,2
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,9,6,6,2,6,2,2,1
 closed,9,4,4,2,4,2,2,0
 wf,58,1,4;state,11
 wf,58,7,4;state,8
 wf,58,6,4;state,8
 wf,58,4,4;state,8
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,58,1,4
 occ,9,5,5,2,5,2,2,1
 closed,9,4,4,2,4,2,2,0
}

scf(i)=energy
!_CC_NORM_MAX=2.0
!{rccsd(t),maxit=100;core}
!ccsd(i)=energy

table,scf,!ccsd
type,csv
save

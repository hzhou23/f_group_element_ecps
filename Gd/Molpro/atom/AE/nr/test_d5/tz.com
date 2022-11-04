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

{rks,pbe0
 start,atden
 print,orbitals=2
 wf,68,8,12
 occ,12,6,6,3,6,3,3,1
 closed,10,4,4,2,4,2,2,0
 sym,1,1,1,1,3,2,1,3,2,1,1,3,2
 sym,2,1,1,1,1,3,2
 sym,3,1,1,1,1,3,2
 sym,5,1,1,1,1,3,2
 orbital,3202.2
}
{rhf,nitord=40
 start,3202.2
 print,orbitals=2
 wf,68,8,12
 occ,12,6,6,3,6,3,3,1
 closed,10,4,4,2,4,2,2,0
 sym,1,1,1,1,3,2,1,3,2,1,1,3,2
 sym,2,1,1,1,1,3,2
 sym,3,1,1,1,1,3,2
 sym,5,1,1,1,1,3,2
 orbital,4202.2
}
pop
{multi
 start,4202.2
 maxit,200
 occ,12,6,6,3,6,3,3,1
 closed,10,4,4,2,4,2,2,0
 wf,68,8,12;state,1
 restrict,1,1,5.2
 restrict,1,1,6.2
 restrict,1,1,5.3
 restrict,1,1,6.3
 restrict,1,1,5.5
 restrict,1,1,6.5
 restrict,1,1,11.1
 restrict,1,1,12.1
 restrict,1,1,3.4
 restrict,1,1,3.6
 restrict,1,1,3.7
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,68,8,12
 occ,12,6,6,3,6,3,3,1
 closed,10,4,4,2,4,2,2,0
}
scf(i)=energy
!_CC_NORM_MAX=2.0
!{rccsd(t),maxit=100;core}
!ccsd(i)=energy

table,scf,!ccsd
type,csv
save

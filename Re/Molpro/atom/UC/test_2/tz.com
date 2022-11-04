***,Calculation for Re atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

set,dkroll=1,dkho=10,dkhp=4

geometry={
1
Re
Re  0.0 0.0 0.0
}

basis={
include,../aug-cc-pwCVTZ.basis
}



basis={
include,../contracted.basis
}
{rhf,nitord=60,maxit=60
 start,atden
 print,orbitals=2
 wf,76,1,4
 occ,12,6,6,3,6,3,3,1
 closed,11,6,6,2,6,2,2,1
 sym,1,1,1,1,3,2,1,3,2,1,1,3,2
 orbital,4202.2
}
{multi
 start,4202.2
 occ,12,6,6,3,6,3,3,1
 closed,9,6,6,2,6,2,2,1
 wf,76,1,4;state,2
 wf,76,4,4;state,1
 wf,76,6,4;state,1
 wf,76,7,4;state,1
 natorb,ci,print
 orbital,5202.2
}
pop
basis={
include,../aug-cc-pwCVTZ.basis
}
{multi
 start,5202.2
 occ,12,6,6,3,6,3,3,1
 closed,9,6,6,2,6,2,2,1
 wf,76,1,4;state,2
 wf,76,4,4;state,1
 wf,76,6,4;state,1
 wf,76,7,4;state,1
 natorb,ci,print
 orbital,6202.2
}
{rhf,nitord=1,maxit=0
 start,6202.2
 wf,76,1,4
 occ,12,6,6,3,6,3,3,1
 closed,11,6,6,2,6,2,2,1
 rotate,4.2,6.2,0
 rotate,4.3,6.3,0
 rotate,4.5,6.5,0
}
scf(i)=energy
_CC_NORM_MAX=2.0
{rccsd(t),maxit=100;core,8,5,5,2,5,2,2,1}
ccsd(i)=energy

table,scf,ccsd
type,csv
save

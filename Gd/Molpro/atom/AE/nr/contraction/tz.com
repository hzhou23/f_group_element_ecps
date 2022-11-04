***,Calculation for Gd atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

set,dkroll=1,dkho=10,dkhp=4

geometry={
1
Gd
Gd  0.0 0.0 0.0
}

basis={
include,../aug-cc-pwCVTZ.basis
}



include,../Gd_states_ae.proc

basis={
include,contracted.basis
}
{rks,pbe0
 start,atden
 print,orbitals=2
 wf,64,8,8
 occ,11,6,6,2,6,2,2,1
 closed,10,4,4,2,4,2,2,0
 sym,1,1,1,1,3,2,1,3,2,1,1,3,2
 sym,2,1,1,1,1,3,2
 sym,3,1,1,1,1,3,2
 sym,5,1,1,1,1,3,2
 orbital,3202.2
}
{rhf
 start,3202.2
 print,orbitals=2
 wf,64,8,8
 occ,11,6,6,2,6,2,2,1
 closed,10,4,4,2,4,2,2,0
 sym,1,1,1,1,3,2,1,3,2,1,1,3,2
 sym,2,1,1,1,1,3,2
 sym,3,1,1,1,1,3,2
 sym,5,1,1,1,1,3,2
 orbital,4202.2
}
pop
basis={
include,../aug-cc-pwCVTZ.basis
}
{multi
 start,4202.2
 occ,12,6,6,3,6,3,3,1
 closed,10,4,4,2,4,2,2,0
 wf,64,8,8;state,2
 restrict,1,1,6.2
 restrict,1,1,5.2
 restrict,1,1,6.3
 restrict,1,1,5.3
 restrict,1,1,6.5
 restrict,1,1,5.5
 wf,64,5,8;state,1
 restrict,1,1,6.2
 restrict,1,1,5.2
 restrict,1,1,6.3
 restrict,1,1,5.3
 restrict,1,1,6.5
 restrict,1,1,5.5
 wf,64,3,8;state,1
 restrict,1,1,6.2
 restrict,1,1,5.2
 restrict,1,1,6.3
 restrict,1,1,5.3
 restrict,1,1,6.5
 restrict,1,1,5.5
 wf,64,2,8;state,1
 restrict,1,1,6.2
 restrict,1,1,5.2
 restrict,1,1,6.3
 restrict,1,1,5.3
 restrict,1,1,6.5
 restrict,1,1,5.5
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,64,8,8
 occ,11,6,6,2,6,2,2,1
 closed,10,4,4,2,4,2,2,0
}
{ci;maxit,100;core,8,3,3,2,3,2,2,0
 natorb,ci,print=15
}


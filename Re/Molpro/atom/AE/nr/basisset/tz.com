***,Calculation for Re atom, singlet and triplet
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15


geometry={
1
Re
Re  0.0 0.0 0.0
}

basis={
include,try_contracted.basis
}
{rhf
 start,atden
 print,orbitals=2
 wf,75,1,5
 occ,12,6,6,3,6,3,3,1
 closed,10,6,6,2,6,2,2,1
 sym,1,1,1,1,3,2,1,3,2,1,1,3,2
 restrict,1,1,10.1
 orbital,4202.2
}
{multi
 start,4202.2
 occ,12,6,6,3,6,3,3,1
 closed,9,6,6,2,6,2,2,1
 wf,75,1,5;state,2
 restrict,1,1,10.1
 wf,75,4,5;state,1
 restrict,1,1,10.1
 wf,75,6,5;state,1
 restrict,1,1,10.1
 wf,75,7,5;state,1
 restrict,1,1,10.1
 natorb,ci,print
 orbital,5202.2
}
pop
basis={
include,aug-cc-pwCVTZ.basis
}
{multi
 start,5202.2
 occ,12,6,6,3,6,3,3,1
 closed,9,6,6,2,6,2,2,1
 wf,75,1,5;state,2
 restrict,1,1,10.1
 wf,75,4,5;state,1
 restrict,1,1,10.1
 wf,75,6,5;state,1
 restrict,1,1,10.1
 wf,75,7,5;state,1
 restrict,1,1,10.1
 natorb,ci,print
 orbital,6202.2
}
{rhf,nitord=1,maxit=0
 start,6202.2
 wf,75,1,5
 occ,12,6,6,3,6,3,3,1
 closed,10,6,6,2,6,2,2,1
 restrict,1,1,10.1
}
{ci;maxit,100;core,9,5,5,2,5,2,2,1
 natorb,ci,print=15
}



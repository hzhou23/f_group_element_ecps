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
include,new_contracted.basis
}
{rhf
 start,atden
 print,orbitals=2
 wf,73,4,3
 occ,11,6,6,2,6,3,3,1
 closed,10,6,6,2,6,2,2,1
 sym,1,1,1,1,3,2,1,3,2,1,1,3,2
 orbital,4202.2
}
{multi
 start,4202.2
 occ,12,6,6,3,6,3,3,1
 closed,10,6,6,2,6,2,2,1
 wf,73,4,3;state,3
 wf,73,6,3;state,3
 wf,73,7,3;state,3
 wf,73,1,3;state,1
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
 closed,10,6,6,2,6,2,2,1
 wf,73,4,3;state,3
 wf,73,6,3;state,3
 wf,73,7,3;state,3
 wf,73,1,3;state,1
 natorb,ci,print
 orbital,6202.2
}
{rhf,nitord=1,maxit=0
 start,6202.2
 wf,73,4,3
 occ,11,6,6,2,6,3,3,1
 closed,10,6,6,2,6,2,2,1
}
{ci;maxit,100;core,9,5,5,2,5,2,2,1
 natorb,ci,print=15
}


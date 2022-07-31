***,molecular
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

!!!set,dkroll=1,dkho=99,dkhp=2

angstrom
geometry={
1

H   0.0 0.0 0.0
}

basis={
include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/H_aug-cc-pVTZ.basis
include,H.ccECP.molpro
}

{rhf,maxdis=30,iptyp='DIIS',nitord=30,maxit=100; shift,-1.0,-0.5
 maxit,100
 shift,-0.5,-0.2
 wf,nelec=1,spin=1,sym=1
    occ,1,0,0,0
 closed,0,0,0,0
 print,orbitals=1
}
scf(i)=energy
pop
_CC_NORM_MAX=2.0
!{uccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core;
!THRESH,ENERGY=5.e-6,COEFF=1e-3
!}
ccsd(i)=energy

table,z,scf,ccsd
save, 3.csv, new


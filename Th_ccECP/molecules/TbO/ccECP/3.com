***,molecular
memory,512,m

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

!!!set,dkroll=1,dkho=99,dkhp=2

angstrom
geometry={
2

Tb  0.0 0.0 0.0
O   0.0 0.0 1.4
}

basis={
include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/Tb_aug-cc-pwCVTZ.basis
include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/O_aug-cc-pwCVTZ.basis

include,n28.ecp
include,O.ccECP.molpro
}

{uks,pbe0,maxdis=30,iptyp='DIIS',nitord=50,maxit=200; shift,-0.5,-0.2
 start, H0
 maxit,100
 wf,nelec=25,spin=7,sym=2
    occ,7,4,4,1
 closed,4,2,3,0
}
!{uhf,maxdis=30,iptyp='DIIS',nitord=20,maxit=200; shift,-0.5,-0.2
! maxit,100
! wf,nelec=25,spin=7,sym=2
!    occ,7,4,4,1
! closed,4,2,3,0
! print,orbitals=1
! orbital,2202.2
!}

basis={
include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/Tb_aug-cc-pwCVTZ.basis
include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/O_aug-cc-pwCVTZ.basis

include,pp.molpro
include,O.ccECP.molpro
}

{rhf,maxdis=30,iptyp='DIIS',nitord=20,maxit=200; shift,-0.5,-0.2
 start,2202.2
 maxit,100
 wf,nelec=25,spin=7,sym=2
    occ,7,4,4,1
 closed,4,2,3,0
 print,orbitals=1
}

do i=1,8
	z(i) = 1.4 + 0.1*(i-1)

	angstrom
	geometry={
	2
	
	Tb  0.0 0.0 0.0
	O   0.0 0.0 z(i)
	}

	{rhf,maxdis=30,iptyp='DIIS',nitord=20,maxit=100; shift,-0.5,-0.2
	 maxit,100
	 wf,nelec=25,spin=7,sym=2
	    occ,7,4,4,1
	 closed,4,2,3,0
	 print,orbitals=1
	}

	scf(i)=energy
	pop
	_CC_NORM_MAX=2.0
	{uccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,50;core;
	THRESH,ENERGY=5.e-6,COEFF=1e-3
	}
	ccsd(i)=energy
enddo

A_SCF=0
A_CCSD=0
B_SCF=-15.68691660
B_CCSD=-15.86629837

table,z,scf,ccsd,A_SCF,A_CCSD,B_SCF,B_CCSD
save, 3.csv, new


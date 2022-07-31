***,molecular
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

set,dkroll=1,dkho=99,dkhp=2

do i=4,4
	z(i) = 1.4 + 0.1*(i-1)

	angstrom
	geometry={
	2
	
	Tb  0.0 0.0 0.0
	O   0.0 0.0 z(i)
	}

	basis={
	include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/Tb_con-cc-pVTZ.basis
	include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/O_con-cc-pwVTZ.basis
	}
	{rks,pbe0
	 start, atden
	 maxit,100
	 shift,-0.5,-0.2
	 wf,nelec=73,spin=7,sym=2
	    occ,19,9,9,3
	 closed,16,7,8,2
	}
	{rhf,maxdis=30,iptyp='DIIS',nitord=30,maxit=100; shift,-1.0,-0.5
	 maxit,100
	 shift,-0.5,-0.2
	 wf,nelec=73,spin=7,sym=2
	    occ,19,9,9,3
	 closed,16,7,8,2
	}
	basis={
	include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/Tb_aug-cc-pwCVTZ.basis
	include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/O_aug-cc-pwCVTZ.basis
	}
	{rhf,maxdis=30,iptyp='DIIS',nitord=30,maxit=100; shift,-1.0,-0.5
	 maxit,100
	 shift,-0.5,-0.2
	 wf,nelec=73,spin=7,sym=2
	    occ,19,9,9,3
	 closed,16,7,8,2
	 print,orbitals=1
	}
	scf(i)=energy
	pop
	_CC_NORM_MAX=2.0
	{uccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core;
	THRESH,ENERGY=5.e-6,COEFF=1e-3
	}
	ccsd(i)=energy
enddo

table,z,scf,ccsd
save, 3.csv, new


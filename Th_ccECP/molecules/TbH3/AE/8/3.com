***,molecular
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

set,dkroll=1,dkho=99,dkhp=2

do i=8,8
	z(i) = 1.5 + 0.1*(i-1)
	r = 1.5 + 0.1*(i-1)

	angstrom
	geometry={
	Tb
	H1  Tb  r 
	H2  Tb  r  H1  120
	H3  Tb  r  H1  120  H2  180
	}

	basis={
	include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/Tb_con-cc-pVTZ.basis
	include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/H_con-cc-pVTZ.basis
	}
	{rks,pbe0
	 start, atden
	 maxit,100
	 shift,-0.5,-0.2
	 wf,nelec=68,spin=6,sym=1
	    occ,17,9,8,3
	 closed,15,7,6,3
	}
        {rhf,maxdis=30,iptyp='DIIS',nitord=30,maxit=100; shift,-1.0,-0.5
	 maxit,100
	 shift,-0.5,-0.2
	 wf,nelec=68,spin=6,sym=1
	    occ,17,9,8,3
	 closed,15,7,6,3
	}
	basis={
	include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/Tb_aug-cc-pwCVTZ.basis
	include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/H_aug-cc-pVTZ.basis
	}
        {rhf,maxdis=30,iptyp='DIIS',nitord=30,maxit=100; shift,-1.0,-0.5
	 maxit,100
	 shift,-0.5,-0.2
	 wf,nelec=68,spin=6,sym=1
	 print,orbitals=1
	    occ,17,9,8,3
	 closed,15,7,6,3
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


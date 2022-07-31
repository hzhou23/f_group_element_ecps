***,molecular
memory,1,g

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

set,dkroll=1,dkho=99,dkhp=2

basis={
include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/Tb_con-cc-pVTZ.basis
include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/O_con-cc-pwVTZ.basis
}

do i=5,5
	z(i) = 1.4 + 0.1*(i-1)

	angstrom
	geometry={
	2
	
	Tb  0.0 0.0 0.0
	O   0.0 0.0 z(i)
	}

	{rks,pbe0
	 start, atden
	 maxit,100
	 shift,-1.0,-0.5
	 wf,nelec=73,spin=1 !,sym=1
	 !   occ,18,8,8,3
	 !closed,17,8,8,3
	 print,orbitals=1
	}
	scf(i)=energy
	pop
	_CC_NORM_MAX=2.0
	!rmp2
	!{uccsd(t),shifts=0.2,shiftp=0.2,thrdis=1.0;diis,1,1,15,1;maxit,100;core;
	!THRESH,ENERGY=5.e-6,COEFF=1e-3
	!}
	ccsd(i)=energy
enddo

table,z,scf,ccsd
save, 3.csv, new


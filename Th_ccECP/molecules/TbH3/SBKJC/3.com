***,molecular
memory,512,m

gthresh,twoint=1.e-15
gthresh,oneint=1.e-15

!!!set,dkroll=1,dkho=99,dkhp=2

basis={
include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/Tb_aug-cc-pwCVTZ.basis
include,/global/homes/a/aannabe/docs/Tb_project/ccECP/basis_sets/H_aug-cc-pVTZ.basis

include,pp.molpro
include,H.ccECP.molpro
}

angstrom
geometry={
Tb
H1  Tb  1.4 
H2  Tb  1.4  H1  120
H3  Tb  1.4  H1  120  H2  180
}

{rks,pbe0,maxdis=30,iptyp='DIIS',nitord=50,maxit=200; shift,-1.0,-0.5
 start, H0
 maxit,100
 shift,-0.5,-0.2
 wf,nelec=22,spin=6,sym=1
    occ,6,4,3,1
 closed,4,2,1,1
}

do i=1,11
	z(i) = 1.4 + 0.1*(i-1)
	r = 1.4 + 0.1*(i-1)

	angstrom
	geometry={
	Tb
	H1  Tb  r 
	H2  Tb  r  H1  120
	H3  Tb  r  H1  120  H2  180
	}

        {rks,pbe0,maxdis=30,iptyp='DIIS',nitord=50,maxit=200; shift,-1.0,-0.5
	 !start, H0
	 maxit,100
	 shift,-0.5,-0.2
	 wf,nelec=22,spin=6,sym=1
	    occ,6,4,3,1
	 closed,4,2,1,1
	}
        {rhf,maxdis=30,iptyp='DIIS',nitord=30,maxit=100; shift,-1.0,-0.5
	 maxit,100
	 shift,-0.5,-0.2
	 wf,nelec=22,spin=6,sym=1
	    occ,6,4,3,1
	 closed,4,2,1,1
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


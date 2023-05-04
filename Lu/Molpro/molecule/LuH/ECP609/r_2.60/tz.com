***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Lu, 60, 3 ;
4
1 13.16535714400937   11.0
3 11.00894338904817   144.818928584103070
2 2.15390717764640   -3.76575541590072
2 1.33228558881045   -3.55284890327944
2
2 8.72514885604507  143.19025839377062
2 1.01000000000000   4.70202155437597
2
2 7.21249200804992   77.53794060081010
2 1.54767308425880   8.35166966352288
2
2 3.80167049108491   62.11007782642341
2 3.71213038550597   12.25497491176618
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/messyminus.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Lu_ccsd=-40.53319478
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 12
symm = 1
ss= 0

!There are irrep cards paramters
A1=4
B1=1
B2=1
A2=0


geometry={
    2
    LuH molecule
    Lu 0.0 0.0 0.0
    H 0.0 0.0 2.60
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Lu_ccsd-H_ccsd


table,2.60,scf,ccsd,bind
save
type,csv


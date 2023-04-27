***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Lu, 60, 4 ;
4
1 19.80505380593775  11.0
3 9.82624404593776  217.855591865315250
2 5.00000000000000  -58.38448792450471
2 3.26294313541329  -0.07095903974103
2
2 6.99757180724091  200.08079886628161
2 4.20323929312433  -4.02649422905799
2
2 7.28361768771788  9.37572250044135
2 2.47403541592714  22.84214331173100
2
2 7.90262143684113  39.91731094729793
2 1.42550806182312  4.12064029714280
2
2 1.09238330282668  4.85101487807663
2 2.02216161122899  -12.51077360162869
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/messyminus.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Lu_ccsd=-42.19820890
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


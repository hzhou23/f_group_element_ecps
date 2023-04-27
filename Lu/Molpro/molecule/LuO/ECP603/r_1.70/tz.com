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
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/messyminus.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Lu_ccsd=-42.19820890
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 17
symm = 1
ss= 1

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=0


geometry={
    2
    LuO molecule
    Lu 0.0 0.0 0.0
    O 0.0 0.0 1.70
}
{rhf,nitord=60;
 start,atden
 maxit,200;
 wf,ne-1,symm,ss-1
 occ,A1-1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
 orbital,2202.2
}
{rhf,nitord=60;
 start,2202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
 orbital,3202.2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Lu_ccsd-O_ccsd


table,1.70,scf,ccsd,bind
save
type,csv


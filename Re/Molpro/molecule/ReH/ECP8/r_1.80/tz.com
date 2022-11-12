***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
4
1, 14.43856300487826,  15.0
3, 13.70072542594641,  216.578445073173900
2, 3.29219101046400 , -5.49721606359788
2, 4.19331770527910 , -6.70003369776265
2
2, 12.08785411445883,  471.14756829693255
2, 3.41082980984385 , 15.23816060471739
2
2, 9.37935959702489 , 265.34193195574426
2, 5.25697189466605 , 49.14995642346835
2
2, 5.97709801891587 , 108.77985472332990
2, 4.73187719140004 , 33.35428136185483
2
2, 2.23010981853069 , 16.91896198877052
2, 4.13209264870178 , 17.85440850233959
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Re_ccsd=-78.21449239
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 16
symm = 1
ss= 4

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    ReH molecule
    Re 0.0 0.0 0.0
    H 0.0 0.0 1.80
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1-1,B2-1,A2-1
 sym,1,1,1,1,2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Re_ccsd-H_ccsd


table,1.80,scf,ccsd,bind
save
type,csv


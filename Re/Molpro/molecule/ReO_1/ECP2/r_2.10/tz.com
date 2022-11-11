***,Calculation for Re atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
4
1, 14.43849698180059,  15.0
3, 13.70219656400810,  216.577454727008850
2, 3.28047663554332 , -5.50063512621190
2, 4.18562235051331 , -6.70202074515843
2
2, 12.10374958279863,  471.14755434929430
2, 3.42094564023799 , 15.23721102622675
2
2, 9.39367786640608 , 265.34179686377331
2, 5.27986928347200 , 49.14907258499692
2
2, 5.97320158363548 , 108.77991229140412
2, 4.72869477755761 , 33.35441338727548
2
2, 2.23015629497110 , 16.91895983281659
2, 4.13209726296206 , 17.85440818581154
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Re_ccsd=-78.25310878
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 21
symm = 1
ss= 1

!There are irrep cards paramters
A1=6
B1=2
B2=2
A2=1


geometry={
    2
    ReO molecule
    Re 0.0 0.0 0.0
    O 0.0 0.0 2.10
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Re_ccsd-O_ccsd


table,2.10,scf,ccsd,bind
save
type,csv


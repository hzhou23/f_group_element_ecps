***,Calculation for Re atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
4
1, 14.43858197730554,  15.0
3, 13.70029595165646,  216.578729659583100
2, 3.29927516253229 , -5.49558039074243
2, 4.19727014932439 , -6.69918694544007
2
2, 12.12898731781881,  471.14756452551740
2, 3.40947247372684 , 15.23822449182867
2
2, 9.37609131276246 , 265.34196323120545
2, 5.25149797523208 , 49.15016358664734
2
2, 5.96762049304627 , 108.78000399173234
2, 4.72455762739864 , 33.35460647885711
2
2, 2.23009559091282 , 16.91896265085092
2, 4.13209123073181 , 17.85440860074520
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


Re_ccsd=-78.19760939
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 21
symm = 1
ss= 5

!There are irrep cards paramters
A1=6
B1=3
B2=3
A2=1


geometry={
    2
    ReO molecule
    Re 0.0 0.0 0.0
    O 0.0 0.0 2.40
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Re_ccsd-O_ccsd


table,2.40,scf,ccsd,bind
save
type,csv


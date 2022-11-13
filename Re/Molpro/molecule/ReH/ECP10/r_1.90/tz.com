***,Calculation for Y atom, singlet and triplet
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
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Re_ccsd=-78.19760939
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
    H 0.0 0.0 1.90
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


table,1.90,scf,ccsd,bind
save
type,csv


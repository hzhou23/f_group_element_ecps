***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Lu, 60, 3 ;
4
1, 11.10845774674712,   11.0
3, 15.15894010252999,   122.193035214218320
2, 3.57299439090350 ,  -6.46946191133872
2, 1.93993914670122 ,  -6.48419576656866
2
2, 7.66609257643265 , 141.25146235573840
2, 2.74312185733708 ,  14.04146519473364
2
2, 6.37237069742855 ,  81.17370681786659
2, 2.43782656805934 ,  14.90359957816819
2
2, 4.25032016396475 ,  55.31101229458964
2, 2.04140582971242 ,  4.91800515964609
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


Lu_ccsd=-40.57444270
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
    O 0.0 0.0 2.50
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


table,2.50,scf,ccsd,bind
save
type,csv


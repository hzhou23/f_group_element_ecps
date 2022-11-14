***,Calculation for Re atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
4
1, 14.05018977873791,  15.0
3, 12.76891924792041,  210.752846681068650
2, 3.59570794249007 , -7.54048175432679
2, 3.35047655752209 , -9.52867960497132
2
2, 11.63364570916874,  470.97279715848964
2, 2.99054074864310 , 14.79694543143510
2
2, 8.96668367023625 , 265.36144024810972
2, 4.89384920293343 , 49.48752430440230
2
2, 6.33251340074305 , 108.02686814959175
2, 3.82953076591716 , 31.99451787475527
2
2, 2.27551705833212 , 16.92023016843453
2, 3.94567742831904 , 17.86308986904444
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


Re_ccsd=-78.24932216
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
    O 0.0 0.0 2.20
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


table,2.20,scf,ccsd,bind
save
type,csv


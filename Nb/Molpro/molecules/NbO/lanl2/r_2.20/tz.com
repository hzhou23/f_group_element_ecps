***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, nb, 28, 3 ;
5; !  ul potential
0,342.9638405,-0.0447401;
1,139.9308014,-20.0535100;
2,43.3523405,-103.7244021;
2,12.4448533,-41.0459165;
2,4.3204837,-4.2046219;
3; !  s-ul potential
0,112.8630617,2.7964669;
1,22.9678676,42.8845786;
2,4.9340673,75.1876966;
4; !  p-ul potential
0,63.6801963,4.9461846;
1,23.0912429,24.8316376;
2,24.4283647,137.9183292;
2,4.2310090,50.9778471;
5; !  d-ul potential
0,99.3359636,3.0064059;
1,64.0586472,25.5347458;
2,37.0891011,178.9597452;
2,12.0708574,92.9577490;
2,3.1575323,18.4744256;
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/Nb-aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Nb_ccsd=-56.16927899
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 19
symm = 1
ss= 3

!There are irrep cards paramters
A1=4
B1=3
B2=3
A2=1


geometry={
    2
    YH molecule
    Nb 0.0 0.0 0.0
    O 0.0 0.0 2.20
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2-1,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Nb_ccsd-O_ccsd


table,2.20,scf,ccsd,bind
save
type,csv

***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-12


basis={
ECP, y, 28, 3 ;
4;
1,11.32216352394507,11.0
3,15.69582425055215,124.543798763395770
2,5.06791160426216,-20.04924398411820
2,4.44452608807987,-5.92948673415386
2;
2,6.86832537504466,154.15919867430935
2,3.83089977201277,18.38958965629789
2;
2,6.19374438133321,106.09583894990516
2,2.73929598061614,10.23789281785987
2;
2,5.30140448642357,48.14642857868520
2,2.23685208658110,7.59284283245229
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/Y-aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Y_ccsd=-38.16578534
O_ccsd=-15.85572648

!These are the wf cards parameters
ne = 17
symm = 1
ss=1

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=0


geometry={
    2
    YO molecule
    Y 0.0 0.0 0.0
    O 0.0 0.0 1.50
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
bind=ccsd-Y_ccsd-O_ccsd


table,1.50,scf,ccsd,bind
save
type,csv


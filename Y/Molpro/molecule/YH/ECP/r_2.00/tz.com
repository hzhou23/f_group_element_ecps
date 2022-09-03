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
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Y-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Y_ccsd=-38.16578534
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
    YH molecule
    Y 0.0 0.0 0.0
    H 0.0 0.0 2.00
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
bind=ccsd-Y_ccsd-H_ccsd


table,2.00,scf,ccsd,bind
save
type,csv


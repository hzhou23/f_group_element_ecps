***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-12


basis={
ECP, y, 28, 3 ;
5;
0,578.4310349,-0.0404817;
1,152.7792004,-20.6194344;
2,44.9301524,-116.7522279;
2,11.4587918,-43.7975806;
2,3.7523267,-5.4247609;
4;
0,59.4715114,2.9801339;
1,17.2173553,34.7834676;
2,18.4797093,28.8453246;
2,4.3276192,64.7642088;
4;
0,45.7271005,4.9885783;
1,49.4595886,19.6506564;
2,18.9952373,194.0943181;
2,3.6603193,43.1349769;
5;
0,62.8268435,3.0066647;
1,31.8897904,25.9879250;
2,18.3646572,85.7172897;
2,7.3062400,48.7792568;
2,2.4051635,11.4535104;
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Y-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Y_ccsd=-37.82677080
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
    H 0.0 0.0 2.30
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


table,2.30,scf,ccsd,bind
save
type,csv


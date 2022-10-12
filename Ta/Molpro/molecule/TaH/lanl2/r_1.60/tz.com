***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
6; !  ul potential
1,768.2267533,-60.0000000;
2,173.5940218,-629.7129313;
2,43.7042268,-221.1750503;
2,11.6181319,-83.4769683;
2,4.0314618,-17.8370275;
2,1.0905378,-0.8160609;
7; !  s-ul potential
0,365.4111559,3.0000000;
1,697.1300915,33.9798985;
2,271.7810379,1242.5776244;
2,87.3074263,706.1663884;
2,22.7492339,276.2464563;
2,3.8680082,513.2283132;
2,3.6718891,-412.9601916;
5; !  p-ul potential
0,228.2107367,2.0000000;
1,62.6185462,61.8174163;
2,19.6465670,194.4975479;
2,3.3651559,307.8346671;
2,3.1497236,-230.6346381;
5; !  d-ul potential
0,151.2755554,3.0000000;
1,67.9794911,55.2670978;
2,34.7474706,236.2957545;
2,11.5656425,134.4755072;
2,3.2930148,41.1401183;
5; !  f-ul potential
0,82.8368029,4.0000000;
1,38.0719872,50.7533760;
2,17.4547034,162.0312877;
2,5.6785931,72.0619298;
2,1.5814041,6.0009895;
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.54698452
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 14
symm = 1
ss= 4

!There are irrep cards paramters
A1=4
B1=2
B2=2
A2=1


geometry={
    2
    TaH molecule
    Ta 0.0 0.0 0.0
    H 0.0 0.0 1.60
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
bind=ccsd-Ta_ccsd-H_ccsd


table,1.60,scf,ccsd,bind
save
type,csv


***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, rh, 28, 3 ;
5; !  ul potential
2,5.26849985,-3.34650707;
2,14.52709961,-36.27990723;
2,39.89099884,-79.27825165;
2,135.15080261,-219.38746643;
1,451.73019409,-24.89464378;
7; !  s-ul potential
2,2.33960009,-26.99048614;
2,2.77189994,88.46970367;
2,3.75909996,-175.11592102;
2,5.70620012,340.60363770;
2,8.72089958,-223.21163940;
1,13.09829998,47.58080292;
0,91.69550323,2.79638195;
7; !  p-ul potential
2,2.27749991,-22.92908096;
2,2.70799994,84.58609009;
2,3.56419992,-171.19743347;
2,5.25099993,316.75189209;
2,7.78830004,-225.04205322;
1,11.98419952,49.74481964;
0,70.47000122,4.39694500;
7; !  d-ul potential
2,2.72009993,40.01486969;
2,3.25489998,-131.79638672;
2,4.54110003,277.17028809;
2,6.98999977,-353.21633911;
2,11.21280003,332.40838623;
1,36.28559875,13.58090496;
0,30.69669914,7.15987301;
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Rh-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Rh_ccsd=-109.98460230
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 18
symm = 1
ss= 2

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    RhH molecule
    Rh 0.0 0.0 0.0
    H 0.0 0.0 1.50
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Rh_ccsd-H_ccsd


table,1.50,scf,ccsd,bind
save
type,csv


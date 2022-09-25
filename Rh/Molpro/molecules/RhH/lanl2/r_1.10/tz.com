***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, rh, 28, 3 ;
5; !  ul potential
0,600.3243032,-0.0538958;
1,157.6910176,-20.1316282;
2,49.8841995,-105.3654121;
2,15.5966895,-42.3274370;
2,5.5099296,-3.6654043;
5; !  s-ul potential
0,59.3442526,2.9753728;
1,83.7426061,25.1230306;
2,18.4530248,626.0926145;
2,12.4194606,-812.2549385;
2,8.8172913,467.3729340;
5; !  p-ul potential
0,53.4309068,4.9537213;
1,65.6671843,20.4871116;
2,16.8369862,598.0120139;
2,11.3042136,-718.4059028;
2,8.0312444,382.8173151;
4; !  d-ul potential
0,64.3993653,3.0279532;
1,43.4625053,24.7526516;
2,19.4020301,142.6844289;
2,4.6879328,32.1406857;
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Rh-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Rh_ccsd=-109.44540535
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
    H 0.0 0.0 1.10
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


table,1.10,scf,ccsd,bind
save
type,csv


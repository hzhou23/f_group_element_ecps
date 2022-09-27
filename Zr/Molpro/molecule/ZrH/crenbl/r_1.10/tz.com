***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, zr, 28, 3 ;
5; !  ul potential
2,1.96560001,-0.27778301;
2,4.82639980,-6.66180706;
2,12.26459980,-38.94683075;
2,38.00030136,-86.41357422;
1,114.34359741,-20.21328354;
7; !  s-ul potential
2,2.70860004,51.15351486;
2,3.23639989,-166.17219543;
2,4.53420019,354.62121582;
2,6.97310019,-347.42883301;
2,10.91759968,262.91113281;
1,42.70869827,44.85594177;
0,158.05920410,2.81595111;
7; !  p-ul potential
2,2.57399988,53.14321518;
2,3.03749990,-172.25927734;
2,4.15030003,357.74844360;
2,6.21470022,-387.61001587;
2,9.40369987,275.60794067;
1,29.28240013,12.65426922;
0,25.48209953,5.28926516;
7; !  d-ul potential
2,1.78410006,35.59209442;
2,2.08969998,-115.19468689;
2,2.79329991,225.52505493;
2,4.06930017,-291.76715088;
2,5.94059992,232.36845398;
1,18.74440002,11.23965740;
0,16.13680077,7.27583790;
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Zr-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Zr_ccsd=-46.74361070
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 13
symm = 2
ss= 1

!There are irrep cards paramters
A1=4
B1=2
B2=1
A2=0


geometry={
    2
    YH molecule
    Zr 0.0 0.0 0.0
    H 0.0 0.0 1.10
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Zr_ccsd-H_ccsd


table,1.10,scf,ccsd,bind
save
type,csv

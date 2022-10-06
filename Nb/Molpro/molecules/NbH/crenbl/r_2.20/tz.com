***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, nb, 28, 3 ;
5; !  ul potential
2,3.44460011,-2.12992907;
2,9.11340046,-22.97262573;
2,22.98679924,-56.91117859;
2,76.26629639,-145.99894714;
1,234.28889465,-21.96123505;
7; !  s-ul potential
2,2.88310003,51.21849060;
2,3.43950009,-165.87748718;
2,4.80849981,353.43283081;
2,7.36780024,-339.01223755;
2,11.54769993,273.15057373;
1,37.81430054,19.10134315;
0,33.57780075,3.36632800;
7; !  p-ul potential
2,2.75320005,52.35134125;
2,3.24040008,-168.72013855;
2,4.41370010,349.30529785;
2,6.57270002,-368.03564453;
2,9.91119957,271.09564209;
1,29.60670090,13.24002266;
0,25.94729996,5.32180595;
7; !  d-ul potential
2,1.90470004,34.02252197;
2,2.22099996,-109.34761810;
2,2.94840002,211.43179321;
2,4.25290012,-270.02197266;
2,6.14580011,220.20515442;
1,18.43989944,11.01616001;
0,15.86740017,7.31999588;
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Nb-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Nb_ccsd=-56.62932756
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
    YH molecule
    Nb 0.0 0.0 0.0
    H 0.0 0.0 2.20
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
bind=ccsd-Nb_ccsd-H_ccsd


table,2.20,scf,ccsd,bind
save
type,csv


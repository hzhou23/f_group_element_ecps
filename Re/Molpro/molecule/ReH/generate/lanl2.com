***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
6; !  ul potential
1,1833.8143836,-0.1497104;
2,414.0589456,-1669.2555781;
2,59.0349540,-346.6661129;
2,11.9177094,-96.6684892;
2,3.6531764,-11.0738567;
2,1.2764184,-0.5798552;
7; !  s-ul potential
0,247.0023085,3.1497104;
1,631.7195767,45.2969969;
2,249.2800441,1116.4279585;
2,84.2947315,793.6419065;
2,23.0407912,318.2099193;
2,4.2997111,586.3105025;
2,4.0974390,-475.6904164;
5; !  p-ul potential
0,193.6897726,2.1497104;
1,56.9308394,64.2295736;
2,18.7227602,218.8504607;
2,3.7340020,344.4189168;
2,3.5127483,-260.4727267;
5; !  d-ul potential
0,126.2340824,3.1497104;
1,80.7090826,46.5714868;
2,42.5529714,304.3834595;
2,13.4074494,157.1589652;
2,3.6904228,48.5701211;
5; !  f-ul potential
0,112.7786459,3.9569610;
1,56.7815968,52.3586781;
2,28.5831966,236.0340824;
2,8.5734158,116.5787266;
2,2.0892721,11.1050530;
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Re_ccsd=-78.89766513
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 16
symm = 1
ss= 4

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    ReH molecule
    Re 0.0 0.0 0.0
    H 0.0 0.0 length
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
bind=ccsd-Re_ccsd-H_ccsd


table,length,scf,ccsd,bind
save
type,csv

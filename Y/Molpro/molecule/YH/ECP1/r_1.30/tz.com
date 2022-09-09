***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-12


basis={
ECP, y, 28, 3 ;
4;
1,12.40896637939774,11.0
3,15.80602917801566,136.498630173375140
2,4.89236226668083,-19.12628145951721
2,3.73652172617038,-5.93011328794829
2;
2,6.31351088446195,155.09372781011740
2,4.89187985095427,21.71934662982254
2;
2,5.81562987981247,105.23477094028871
2,2.82128466097255,9.75732302008167
2;
2,4.60723168612415,48.11573593231709
2,2.80189736059088,10.19866807694907
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
    H 0.0 0.0 1.30
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


table,1.30,scf,ccsd,bind
save
type,csv


***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 8.39591855732551 , 13.0
3, 7.37286292331927 , 109.146941245231630
2, 3.59266705502262 , -6.97786880776556
2, 2.53002503347401 , -9.09058904984734
4
2, 15.78265881902567,  354.34497747304079
4, 4.73140156155340 , -3.36291197424236
2, 6.42249834782783 , 14.71521735205340
2, 2.33565669349034 , 13.55853730869270
4
2, 7.33406657797382 , 292.77152864401853
4, 6.95327134879809 , -10.22941613131565
2, 4.81114762146012 , 5.35609845909410
2, 5.10296315262077 , 9.36567288273615
4
2, 4.74986524110138 , 115.85664839865098
4, 6.57684486761806 , -0.64294908031154
2, 9.87507291582495 , 5.36997948266981
2, 6.28679629657445 , 12.55040487466287
2
2, 1.80212831289435 , 13.58754476820762
2, 3.31609402113527 , 12.94363624966530
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-56.83897429
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
bind=ccsd-Ta_ccsd-H_ccsd


table,2.20,scf,ccsd,bind
save
type,csv


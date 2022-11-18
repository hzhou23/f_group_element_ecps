***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 7.35783522180766 , 13.0
3, 5.40076820314812 , 95.651857883499580
2, 3.22307720038764 , -0.07893282121621
2, 2.95666554144618 , -8.57369790107260
4
2, 21.42048689050018,  455.06430372645593
4, 7.08651203984714 , 7.60448666650966
2, 1.78648831541817 , -6.07774270384344
2, 4.05054894445721 , 34.76208983655465
4
2, 11.19382486717620,  334.88205852882464
4, 9.90446979712992 , 9.66412424579889
2, 7.68067003989395 , -1.98403123865515
2, 4.01441016326656 , 1.49584776087929
4
2, 6.79027178668378 , 110.71898694307792
4, 3.10781234965810 , 3.46256636084654
2, 1.01000000143642 , -0.91211182193619
2, 3.56972931481443 , 16.92788635932609
2
2, 3.62501415455700 , 13.12223972828046
2, 1.92089124058188 , 12.75786332283285
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.42771806
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
    H 0.0 0.0 2.10
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


table,2.10,scf,ccsd,bind
save
type,csv


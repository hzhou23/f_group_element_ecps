***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 11.91320711081554,  13.0
3, 10.70809781517836,  154.871692440602020
2, 1.75434310797050 , -0.41701187844425
2, 1.67769019012863 , -1.91373058935476
2
2, 14.20088443773864,  459.67879294579944
2, 4.25645541067003 , 24.89099983977080
2
2, 13.37675513298234,  378.63844005517069
2, 3.70942948904331 , 26.42703873541400
2
2, 5.74629088894767 , 106.69333816136913
2, 4.29477898004367 , 23.02779633683486
2
2, 2.96085581196117 , 12.35711719923719
2, 1.91422038879091 , 12.20938858153065
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.47612209
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

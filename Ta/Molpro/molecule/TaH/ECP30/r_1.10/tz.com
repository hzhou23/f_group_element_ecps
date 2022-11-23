***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 11.59776397189709,  13.0
3, 10.30993554746943,  150.770931634662170
2, 7.56435036926696 , -5.16579651360517
2, 1.06078011952243 , -0.25301141831400
2
2, 13.92143967707804,  459.65971069859705
2, 3.65155183768487 , 12.15519028726016
2
2, 10.78514016520376,  378.26612169656181
2, 4.34686040199295 , 17.15016968681727
2
2, 6.03276113025771 , 109.95530480235156
2, 5.62024493515877 , 28.61125948107140
2
2, 6.81575376235230 , 11.99734986096493
2, 1.89682361594309 , 11.85193143502216
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.08395057
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
    H 0.0 0.0 1.10
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


table,1.10,scf,ccsd,bind
save
type,csv


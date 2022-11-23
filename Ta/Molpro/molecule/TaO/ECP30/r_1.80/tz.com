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
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Ta_ccsd=-57.08395057
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 19
symm = 1
ss= 3

!There are irrep cards paramters
A1=4
B1=3
B2=3
A2=1


geometry={
    2
    TaH molecule
    Ta 0.0 0.0 0.0
    O 0.0 0.0 1.80
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2-1,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Ta_ccsd-O_ccsd


table,1.80,scf,ccsd,bind
save
type,csv


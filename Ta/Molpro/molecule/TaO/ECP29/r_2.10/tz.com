***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 11.59761841744373,  13.0
3, 10.31134182538065,  150.769039426768490
2, 7.56422826774257 , -5.16594232496994
2, 1.06079303145070 , -0.23768823490065
2
2, 13.92943810112238,  459.65964810634023
2, 3.67787769377198 , 12.15245079728659
2
2, 10.74684591827618,  378.26621818108237
2, 4.32431147960501 , 17.15228424017296
2
2, 6.03446720667145 , 109.95527664454291
2, 5.62094544802257 , 28.61121908058095
2
2, 6.81575128561277 , 11.99735029498906
2, 1.89625271442792 , 11.85196212882447
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


Ta_ccsd=-57.02525360
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
    O 0.0 0.0 2.10
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


table,2.10,scf,ccsd,bind
save
type,csv


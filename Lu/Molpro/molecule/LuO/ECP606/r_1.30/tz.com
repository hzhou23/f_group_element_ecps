***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Lu, 60, 3 ;
4
1, 11.16811851879913,   11.0
3, 15.30685140887570,   122.849303706790430
2, 2.14365454390834 ,  -5.61769790215767
2, 1.82275380439372 ,  -3.70799122472961
2
2, 8.73575087364173 , 141.09797610770298
2, 1.88229330495330 ,  10.78554807456094
2
2, 6.96335917251083 ,  80.70279058193925
2, 1.99314182512186 ,  12.19064028985444
2
2, 3.84520171477929 ,  57.00068609485209
2, 3.85205789419056 ,  11.95112553894034
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/messyminus.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Lu_ccsd=-40.33554373
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 17
symm = 1
ss= 1

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=0


geometry={
    2
    LuO molecule
    Lu 0.0 0.0 0.0
    O 0.0 0.0 1.30
}
{rhf,nitord=60;
 start,atden
 maxit,200;
 wf,ne-1,symm,ss-1
 occ,A1-1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
 orbital,2202.2
}
{rhf,nitord=60;
 start,2202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
 orbital,3202.2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Lu_ccsd-O_ccsd


table,1.30,scf,ccsd,bind
save
type,csv


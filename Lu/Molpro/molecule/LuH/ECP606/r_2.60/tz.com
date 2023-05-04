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
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/messyminus.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Lu_ccsd=-40.33554373
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
    LuH molecule
    Lu 0.0 0.0 0.0
    H 0.0 0.0 2.60
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
bind=ccsd-Lu_ccsd-H_ccsd


table,2.60,scf,ccsd,bind
save
type,csv


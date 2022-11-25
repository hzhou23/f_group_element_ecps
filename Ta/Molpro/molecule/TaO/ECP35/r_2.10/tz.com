***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 8.39591014779667 , 13.0
3, 7.37294320814690 , 109.146831921356710
2, 3.59221780807861 , -6.97792175162901
2, 2.52714088025842 , -9.09081033069424
4
2, 15.78273537078577,  354.34497639412774
4, 4.73133350553020 , -3.36294197119922
2, 6.42265652095553 , 14.71519505791172
2, 2.33873850112960 , 13.55826468996918
4
2, 7.33013585093530 , 292.77155493326347
4, 6.95337306366276 , -10.22939946479996
2, 4.81078501773162 , 5.35620738155931
2, 5.10244718052372 , 9.36576361416662
4
2, 4.75623265887059 , 115.85657387873145
4, 6.57683864415208 , -0.64294126873341
2, 9.87508201866972 , 5.36997647542533
2, 6.28700101346890 , 12.55037797458292
2
2, 1.80211730344282 , 13.58754525043438
2, 3.31609311752469 , 12.94363631565316
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


Ta_ccsd=-56.85329250
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


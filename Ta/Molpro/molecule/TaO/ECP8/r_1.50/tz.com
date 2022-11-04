***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 8.77790117627654 , 13.0
3, 6.48149180155711 , 114.112715291595020
2, 1.19085397255519 , -2.04898002197270
2, 7.92583251619790 , -3.21619546558884
4
2, 16.13993175162957,  254.01928334447388
4, 2.93128262881855 , 3.81550524440964
2, 1.70738984621322 , 0.67282061733050
2, 3.58612911311473 , 8.00492701798377
4
2, 8.14311755601626 , 293.05690801485002
4, 6.74560826496179 , 11.22141465551174
2, 4.60658981856390 , -2.25732484440155
2, 7.96664053782118 , 17.52882639123408
4
2, 9.30298627335207 , 114.67213803326901
4, 1.56979026745126 , 1.48997099574140
2, 1.57389889274898 , 2.12000267087927
2, 3.50380794298312 , 9.29197330028284
2
2, 6.90787427695400 , 13.37652354013105
2, 1.67272692693566 , 13.12049063791291
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


Ta_ccsd=-56.70243260
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
    O 0.0 0.0 1.50
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


table,1.50,scf,ccsd,bind
save
type,csv


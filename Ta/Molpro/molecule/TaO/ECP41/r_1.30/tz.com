***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 6.22277547622137 , 13.0
3, 9.46199566781226 , 80.896081190877810
2, 10.00000000000000,  -0.01187830995750
2, 1.51182272154401 , -1.35101140330964
4
2, 16.56930101377441,  354.55483305068651
4, 5.49009104528294 , -2.44698885633796
2, 6.33388517706123 , 15.91973790594979
2, 4.29260816407439 , 17.51036994772198
4
2, 9.70661784719624 , 291.17021528555273
4, 9.20736952888341 , -10.80861552745203
2, 3.20730360963005 , -1.85816524133517
2, 2.20803594203658 , 4.32533814066039
4
2, 5.88366641855202 , 120.57408652791342
4, 6.20647508214972 , -3.30337622290122
2, 5.80940115627031 , 6.43089775145994
2, 5.15165266139958 , 15.81868406718569
2
2, 1.88800902687763 , 13.75856785152156
2, 3.80730354125196 , 12.93477243719946
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


Ta_ccsd=-57.33004946
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
    O 0.0 0.0 1.30
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


table,1.30,scf,ccsd,bind
save
type,csv


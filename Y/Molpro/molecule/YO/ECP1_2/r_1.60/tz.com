***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-12


basis={
ECP, y, 28, 3 ;
4;
1,4.87100293882792,11.0
3,20.55358276995978,53.581032327107120
2,5.61825806517946,-10.60819260879985
2,1.01000000000000,-1.53101668623099
2;
2,6.30407178703926,169.18950042035391
2,8.39093198664959,28.12968318764126
2;
2,6.82105997755958,75.58642402951072
2,2.13852940572150,10.51639695984290
2;
2,3.71825977681228,65.15355117473580
2,5.77940393483957,18.33403057279614
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/Y-aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Y_ccsd=-38.16817253
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 17
symm = 1
ss=1

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=0


geometry={
    2
    YO molecule
    Y 0.0 0.0 0.0
    O 0.0 0.0 1.60
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Y_ccsd-O_ccsd


table,1.60,scf,ccsd,bind
save
type,csv


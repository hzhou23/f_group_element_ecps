***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 5.51381162481927 , 13.0
3, 7.44023688553307 , 71.679551122650510
2, 6.46711456726471 , -4.30699257466320
2, 2.49908906750668 , 1.234000000000000
4
2, 15.58862294664662,  354.58930661569656
4, 2.75577479494782 , -6.05061900298280
2, 10.65475241520931,  15.35411289400539
2, 5.17511570569688 , 24.78696761179354
4
2, 11.09310542636039,  290.21967880128466
4, 8.73534400244057 , -12.51869998550155
2, 1.01000000000000 , -5.41857066734325
2, 1.44190924855287 , 9.48101569380436
4
2, 6.48219541530707 , 122.22049919163408
4, 8.96694219606174 , -9.72701595043986
2, 5.50755923860412 , 5.40961379771644
2, 7.61430452006915 , 14.93802490219636
2
2, 1.92694647065041 , 13.61349229546305
2, 4.70373773488592 , 12.89155307351928
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


Ta_ccsd=-56.40056313
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
    O 0.0 0.0 2.20
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


table,2.20,scf,ccsd,bind
save
type,csv

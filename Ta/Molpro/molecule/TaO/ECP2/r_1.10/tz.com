***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 5.20982392529111  , 13.0
3, 5.09399548573342 , 67.727711028784430
2, 3.70445534660977 , -0.69133849935939
2, 2.38077411794044 , -5.81916968993469
4
2, 22.10053478788410,  454.94461998019756
4, 10.17315767085040,  3.58069870520996
2, 2.75203567230649 , -4.62461718596031
2, 5.46083131818003 , 32.22883204413273
4
2, 12.04028939214843,  335.40746473427475
4, 10.55513340252588,  9.56743534086559
2, 7.20809953078667 , -0.53106943341786
2, 4.76859380681340 , 7.52920695411258
4
2, 6.43795216578077 , 110.71219362448436
4, 3.69083081960298 , 2.97126768480741
2, 2.00599681610437 , -1.53926955759768
2, 4.54341748841160 , 16.08302174485260
2
2, 3.32364009622465 , 12.97554959926653
2, 2.02110996202473 , 12.71836444879025
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


Ta_ccsd=-57.45209644
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
    O 0.0 0.0 1.10
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


table,1.10,scf,ccsd,bind
save
type,csv


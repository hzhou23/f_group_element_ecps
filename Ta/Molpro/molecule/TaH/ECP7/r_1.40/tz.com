***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 9.49311870686345 , 13.0
3, 6.52085529849528 , 123.410543189224850
2, 4.54852724216442 , -4.73449078734683
2, 5.34172619172436 , -7.50546013436257
4
2, 13.07873302279085,  254.43997717456551
4, 5.18864520513627 , 3.14777906501094
2, 2.35669487597898 , -3.04066903258018
2, 4.53637010512491 , 14.18820643516677
4
2, 10.65795736184987,  292.80527884557421
4, 8.94538106190875 , 11.07890812713315
2, 5.07331737044059 , -1.98540228568533
2, 5.20359658533699 , 12.12061308662383
4
2, 7.35217409620405 , 115.53347576181459
4, 5.88059141872319 , 1.27662077230424
2, 1.63874139966544 , 0.14015790891126
2, 4.58548053505171 , 12.40740543214276
2
2, 4.26280044576577 , 13.45948521384453
2, 2.18394889531236 , 13.01324535814453
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-56.82222559
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 14
symm = 1
ss= 4

!There are irrep cards paramters
A1=4
B1=2
B2=2
A2=1


geometry={
    2
    TaH molecule
    Ta 0.0 0.0 0.0
    H 0.0 0.0 1.40
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1-1,B2-1,A2-1
 sym,1,1,1,1,2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Ta_ccsd-H_ccsd


table,1.40,scf,ccsd,bind
save
type,csv


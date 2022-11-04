***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 9.47589038609703 , 13.0
3, 6.54140679181925 , 123.186575019261390
2, 4.52381663213571 , -4.75476689603843
2, 5.32019300387546 , -7.52215904754007
4
2, 13.30709206680405,  254.43680839142809
4, 5.16919083250509 , 3.14665075411094
2, 2.56045311307125 , -3.05445640895647
2, 4.44233634992588 , 14.17137616368760
4
2, 10.54553425908456,  292.80643206598739
4, 8.94374511792760 , 11.08025469074613
2, 5.07032113270408 , -1.97562466338820
2, 5.20613448013150 , 12.12700154192318
4
2, 7.27399524667274 , 115.53495871907319
4, 5.88056778280685 , 1.28001658915173
2, 1.38757827083343 , 0.12720601860614
2, 4.57105174234466 , 12.41105074863345
2
2, 4.25990657907260 , 13.45980086759546
2, 2.04497793022864 , 13.01941999274742
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


Ta_ccsd=-56.73519540
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
    O 0.0 0.0 1.70
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


table,1.70,scf,ccsd,bind
save
type,csv


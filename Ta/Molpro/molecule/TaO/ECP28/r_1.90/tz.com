***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 11.59846713318753,  13.0
3, 10.30138310915892,  150.780072731437890
2, 7.56606428986412 , -5.16510429265123
2, 1.06079938137337 , -0.21441363222078
2
2, 13.93075460859432,  459.65969585668159
2, 3.66145249291283 , 12.15492338265921
2
2, 10.74802166865865,  378.26637823644387
2, 4.28678053197190 , 17.15580752348776
2
2, 6.06201023520961 , 109.95486191028429
2, 5.63071851403519 , 28.61067723258784
2
2, 6.81574909818723 , 11.99735065848355
2, 1.89577196105710 , 11.85198800725011
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


Ta_ccsd=-56.92592794
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
    O 0.0 0.0 1.90
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


table,1.90,scf,ccsd,bind
save
type,csv


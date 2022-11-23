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
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-56.92592794
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


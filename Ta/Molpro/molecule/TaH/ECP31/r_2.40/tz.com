***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 11.54542663317389,  13.0
3, 10.30073261824193,  150.090546231260570
2, 7.44122477816325 , -4.75547879605754
2, 1.01000000000000 , -0.36784358206389
2
2, 13.27097900765338,  459.64894585291336
2, 4.28810379263681 , 14.84059619006059
2
2, 10.32025737794254,  378.18958213046579
2, 4.66669588906523 , 17.72039482261934
2
2, 5.99475553906152 , 109.80138980771386
2, 5.28003453413524 , 28.29124994000736
2
2, 6.79748662433368 , 12.00018406415729
2, 1.71067113262195 , 11.90750585693222
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.28092756
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
    H 0.0 0.0 2.40
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


table,2.40,scf,ccsd,bind
save
type,csv


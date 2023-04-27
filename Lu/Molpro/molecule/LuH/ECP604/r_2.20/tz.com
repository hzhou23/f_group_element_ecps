***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Lu, 60, 3 ;
4
1, 11.96898756632240,   11.0
3, 11.18772892813810,   131.658863229546400
2, 3.99502348829345 ,  -6.34682191614121
2, 2.25379129582714 ,  -6.65092196991013
2,
2, 8.31745285402191 , 141.28341711365573
2, 3.01451808680734 ,  14.11796955623288
2,
2, 6.37036719972606 ,  81.22243719609351
2, 3.29515002182652 ,  15.06103939469560
2,
2, 5.03083846925270 ,  55.23609244784316
2, 2.55964060371634 ,  4.98086991821593
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/messyminus.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Lu_ccsd=-41.82487761
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 12
symm = 1
ss= 0

!There are irrep cards paramters
A1=4
B1=1
B2=1
A2=0


geometry={
    2
    LuH molecule
    Lu 0.0 0.0 0.0
    H 0.0 0.0 2.20
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Lu_ccsd-H_ccsd


table,2.20,scf,ccsd,bind
save
type,csv

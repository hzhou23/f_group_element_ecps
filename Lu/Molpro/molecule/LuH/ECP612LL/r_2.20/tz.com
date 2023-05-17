***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Lu, 60, 3 ;
4
1, 13.66353969160300,   11.0
3, 8.71205256520462 ,  150.298936607633000
2, 2.79812031321838 ,  -1.88412997114224
2, 1.88857096734207 ,  -3.21477380581692
2
2, 7.72008751810712 , 143.32576617604079
2, 1.11998521206715 ,  1.24021251967007
2
2, 7.64542880750659 ,  78.12646045784338
2, 2.72914211069029 ,  13.35685996712544
2
2, 4.46262467822252 ,  61.24404618911561
2, 4.00490178778396 ,  11.32432425179759
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/messyminus.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Lu_ccsd=-39.86972714
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


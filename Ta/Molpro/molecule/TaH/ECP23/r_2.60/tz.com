***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 11.59758991568435,  13.0
3, 10.31204704664821,  150.768668903896550
2, 7.56395736661440 , -5.16599826097209
2, 1.03796969604685 , -0.24366619971744
2
2, 13.95946715183546,  459.65971617318951
2, 3.65749272304418 , 12.15562157626328
2
2, 10.79480910249927,  378.26604750886395
2, 4.35406113378858 , 17.14922657499741
2
2, 6.02285454561391 , 109.95544669641397
2, 5.61708486770160 , 28.61143397742792
2
2, 6.81576146474346 , 11.99734876058946
2, 1.89849343698004 , 11.85184136154177
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.10295730
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
    H 0.0 0.0 2.60
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


table,2.60,scf,ccsd,bind
save
type,csv


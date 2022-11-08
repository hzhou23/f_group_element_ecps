***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
4
1, 13.77358518852697,  15.0
3, 12.81422618104271,  206.603777827904550
2, 3.45957382862448 , -6.18470841425567
2, 4.04830082872267 , -6.83888111232497
2
2, 12.12261064636563,  470.93626394316243
2, 3.40646927245008 , 15.07136483063432
2
2, 9.33615213729083 , 265.39981485722029
2, 5.33164404930460 , 49.65410113902736
2
2, 5.99503640543878 , 108.56708937780061
2, 4.67091887855632 , 32.90396929551129
2
2, 2.23776626687705 , 16.93058067341244
2, 4.08514696781550 , 17.85843486300441
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Re_ccsd=-78.32695789
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 16
symm = 1
ss= 4

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    ReH molecule
    Re 0.0 0.0 0.0
    H 0.0 0.0 1.50
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
bind=ccsd-Re_ccsd-H_ccsd


table,1.50,scf,ccsd,bind
save
type,csv


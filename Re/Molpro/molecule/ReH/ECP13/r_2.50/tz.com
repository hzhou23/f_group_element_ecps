***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
4
1, 14.00022674954528,  15.0
3, 12.99623478596275,  210.003401243179200
2, 4.04914816080926 , -7.97147186403506
2, 4.02762398102479 , -9.87925299085002
2
2, 11.41305252393264,  471.04136887655403
2, 3.96696845658809 , 17.86263561670916
2
2, 9.53397795877572 , 265.26672851316965
2, 4.98803656470393 , 48.50854118075404
2
2, 6.28107391593633 , 107.91928663066766
2, 4.17556135757672 , 31.43535854962401
2
2, 2.53877743187362 , 16.90372368721188
2, 4.02070015034615 , 17.85766400641521
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Re_ccsd=-78.34186539
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
    H 0.0 0.0 2.50
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


table,2.50,scf,ccsd,bind
save
type,csv


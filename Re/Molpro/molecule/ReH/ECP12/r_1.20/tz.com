***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
4
1, 14.03217415590809,  15.0
3, 12.37878195601535,  210.482612338621350
2, 4.13510464844168 , -8.84227144600072
2, 3.32656587417719 , -8.41797057785723
2
2, 12.09720505731674,  471.25549653152109
2, 3.36420226655362 , 18.43943606828873
2
2, 8.24983980371847 , 265.54731080786206
2, 5.76133450333200 , 50.64532212102785
2
2, 6.51515042648658 , 108.54017285087255
2, 3.80366747583870 , 30.60482037829906
2
2, 2.21123580029442 , 16.96598486353070
2, 4.06855790790147 , 17.85940061266256
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Re_ccsd=-78.13963226
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
    H 0.0 0.0 1.20
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


table,1.20,scf,ccsd,bind
save
type,csv


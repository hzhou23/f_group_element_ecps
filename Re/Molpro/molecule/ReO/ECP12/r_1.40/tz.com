***,Calculation for Re atom, singlet and triplet
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


Re_ccsd=-78.13963226
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 21
symm = 1
ss= 5

!There are irrep cards paramters
A1=6
B1=3
B2=3
A2=1


geometry={
    2
    ReO molecule
    Re 0.0 0.0 0.0
    O 0.0 0.0 1.40
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Re_ccsd-O_ccsd


table,1.40,scf,ccsd,bind
save
type,csv


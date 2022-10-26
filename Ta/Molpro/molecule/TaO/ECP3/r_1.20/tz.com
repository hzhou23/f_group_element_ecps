***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 4.97457193632958 , 13.0
3, 5.26023418565353 , 64.669435172284540
2, 2.67197983462605 , -0.47605524943075
2, 2.15817910240543 , -4.21351817610039
4
2, 20.70286031354501,  454.96025660560673
4, 10.02973048304008,  3.47878476450205
2, 3.10272962118842 , -4.19305106472309
2, 6.04457196856476 , 32.58466298556971
4
2, 14.07770029821275,  335.32382043610954
4, 10.67841170611441,  9.55688761498871
2, 7.27226289027606 , -1.06597356003652
2, 3.35050503471790 , 6.21526515818441
4
2, 6.59468869849815 , 110.63182769382087
4, 3.33717093287225 , 3.06285056177862
2, 2.21211584635493 , -3.00775400813279
2, 3.90532938257064 , 15.88040149700235
2
2, 4.91710833772849 , 12.91431890903127
2, 1.93006873288129 , 12.79554014975909
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


Ta_ccsd=-57.48046450
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
    O 0.0 0.0 1.20
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


table,1.20,scf,ccsd,bind
save
type,csv


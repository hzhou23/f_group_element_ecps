***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 11.52668847907439,  13.0
3, 10.23582774434061,  149.846950227967070
2, 7.69152913201334 , -5.08410948336542
2, 1.19909855386176 , -0.27206409777687
2
2, 13.78006217876381,  459.66374912843781
2, 3.76171626793589 , 12.36850328871579
2
2, 10.56223960944087,  378.27274614187178
2, 4.31318240864939 , 17.22758959371997
2
2, 6.09214140703617 , 109.95861638335317
2, 5.36402460996997 , 28.62454507299603
2
2, 6.81494428131636 , 11.99066668621293
2, 1.74852611534671 , 11.86085394407344
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


Ta_ccsd=-56.83114071
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
    O 0.0 0.0 1.80
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


table,1.80,scf,ccsd,bind
save
type,csv


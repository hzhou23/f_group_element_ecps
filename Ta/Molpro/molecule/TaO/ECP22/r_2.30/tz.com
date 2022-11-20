***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 11.49359525482568,  13.0
3, 10.13913654925267,  149.416738312733840
2, 7.97511520789609 , -6.03406515016282
2, 1.01000000000000 , -0.31110729601449
2
2, 14.14612656777027,  459.59879457929856
2, 3.72713175663791 , 12.91274471332207
2
2, 10.89406043961893,  378.24994749881557
2, 4.33871457615221 , 16.98507934717156
2
2, 6.09113600764388 , 110.00602740934724
2, 5.49852442672511 , 28.47691799768191
2
2, 6.76042007200464 , 12.00239531058859
2, 1.89414073170908 , 11.84039532655034
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


Ta_ccsd=-57.29009560
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
    O 0.0 0.0 2.30
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


table,2.30,scf,ccsd,bind
save
type,csv


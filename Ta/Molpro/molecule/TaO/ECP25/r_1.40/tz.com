***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 11.59763423890102,  13.0
3, 10.30444085772715,  150.769245105713260
2, 7.56795623574980 , -5.16562234368678
2, 1.08220514721343 , -0.05030543795228
2
2, 14.11289368233007,  459.65843738089995
2, 4.07780952468083 , 12.09212043206165
2
2, 10.35384120993022,  378.26914249441927
2, 3.70023088350270 , 17.21240663198371
2
2, 6.23202842783333 , 109.95231294585955
2, 5.68813123054174 , 28.60741169751503
2
2, 6.81562599913156 , 11.99736963128376
2, 1.86852465388835 , 11.85345672027205
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


Ta_ccsd=-55.98533639
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
    O 0.0 0.0 1.40
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


table,1.40,scf,ccsd,bind
save
type,csv


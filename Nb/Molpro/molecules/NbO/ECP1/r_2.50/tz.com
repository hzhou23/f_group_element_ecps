***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,Nb,28,4,0
4
1, 19.86089158295794,  13.0
3, 19.52592677324002,  258.191590578453220
2, 7.38820086785453 , -23.26312802426079
2, 4.55864105458634 , -4.88737492545031
2
2, 8.45144984331345 , 188.14727662154681
2, 4.65585389203211 , 25.67388126105923
2
2, 8.19202422427608 , 134.29806965607142
2, 3.46626252816859 , 17.38155611740850
2
2, 6.82507161050075 , 60.15121909620855
2, 2.85815732720811 , 10.39336936151948
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/Nb-aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Nb_ccsd=-56.77143461
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
    YH molecule
    Nb 0.0 0.0 0.0
    O 0.0 0.0 2.50
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
bind=ccsd-Nb_ccsd-O_ccsd


table,2.50,scf,ccsd,bind
save
type,csv


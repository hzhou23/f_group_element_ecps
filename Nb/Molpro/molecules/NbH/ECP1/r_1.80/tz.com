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
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Nb-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Nb_ccsd=-56.77143461
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
    YH molecule
    Nb 0.0 0.0 0.0
    H 0.0 0.0 1.80
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1-1,B2-1,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Nb_ccsd-H_ccsd


table,1.80,scf,ccsd,bind
save
type,csv


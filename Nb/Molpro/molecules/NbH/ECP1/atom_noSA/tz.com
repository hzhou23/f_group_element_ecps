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
include,../../generate/Nb-aug-cc-pwCVTZ.basis
}



geometry={
    1
    Nb molecule
    Nb 0.0 0.0 0.0
}
{rhf,nitord=20;
 maxit,200;
 wf,13,1,5
 occ,3,1,1,1,1,1,1
 closed,1,1,1,0,1,0,0
 sym,1,1,1,3,2
 restrict,1,1,2.1
 print,orbitals=2
}
Nb_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
Nb_ccsd=energy


table,Nb_scf,Nb_ccsd
save
type,csv


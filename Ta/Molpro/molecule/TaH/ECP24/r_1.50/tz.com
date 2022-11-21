***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 11.59955603801382,  13.0
3, 10.28878382727161,  150.794228494179660
2, 7.56839971518148 , -5.16403225888320
2, 1.06720991445458 , -0.14402832208558
2
2, 13.91077612770670,  459.65978721826127
2, 3.63099164341881 , 12.15957777083788
2
2, 10.74047351732486,  378.26642724289638
2, 4.27043588911270 , 17.15718598504107
2
2, 6.04757079405806 , 109.95508182840369
2, 5.62563494478422 , 28.61095965996630
2
2, 6.81575581880497 , 11.99734953847806
2, 1.89725263128968 , 11.85190830922786
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-56.71256273
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
    TaH molecule
    Ta 0.0 0.0 0.0
    H 0.0 0.0 1.50
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
bind=ccsd-Ta_ccsd-H_ccsd


table,1.50,scf,ccsd,bind
save
type,csv


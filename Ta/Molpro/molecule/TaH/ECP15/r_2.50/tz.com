***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 9.50469371190010 , 13.0
3, 6.61590413611784 , 123.561018254701300
2, 4.39652254793804 , -4.77828228927443
2, 5.21864441171281 , -7.52933852166620
4
2, 12.99709105990598,  254.44118945678338
4, 5.18153766726856 , 3.15401064425809
2, 2.51237726558707 , -2.95377206562623
2, 4.54220121407984 , 14.19549413518763
4
2, 10.96711744600450,  292.80246543157511
4, 8.95824448859763 , 11.07619649743044
2, 5.03055131398363 , -2.02129426169965
2, 5.41071566975279 , 12.08855391012265
4
2, 7.40722713832715 , 115.53266960652931
4, 5.88219380575848 , 1.27652666602951
2, 1.64786580454618 , 0.01060438065093
2, 4.63630751286395 , 12.40213544658278
2
2, 4.26702074821111 , 13.45912869267590
2, 2.25186234598797 , 13.00964308630563
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.32981375
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
    H 0.0 0.0 2.50
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


table,2.50,scf,ccsd,bind
save
type,csv


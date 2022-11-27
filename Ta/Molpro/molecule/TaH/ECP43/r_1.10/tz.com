***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 4.32168263241508 , 13.0
3, 6.96176072369861 , 56.181874221396040
2, 10.00000000000000,  -0.28363968806993
2, 2.71233944792430 , -0.13770478278053
4
2, 14.80084774720669,  352.89330944147395
4, 2.52406873850911 , -4.65543489891072
2, 14.38701202502041,  17.02375040569861
2, 8.23921089007605 , 38.72256918634545
4
2, 13.28728103581844,  288.92489558902696
4, 4.22240406580437 , -12.82414956067110
2, 1.01000000000000 , -13.82437002789086
2, 1.27393530013890 , 19.83598894958848
4
2, 7.75535066231043 , 123.15610700857697
4, 10.00000000000000,  -9.48867491291750
2, 1.68473893787203 , 1.18303819815370
2, 9.54008450765152 , 15.42432386524936
2
2, 2.73709268779866 , 13.18536313813843
2, 2.08035364179509 , 13.11515024012137
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-56.92937444
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
    H 0.0 0.0 1.10
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


table,1.10,scf,ccsd,bind
save
type,csv


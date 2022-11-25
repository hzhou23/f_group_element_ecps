***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1 8.39600579483612  13.0
3 7.37183738092785  109.148075332869560
2 3.59420250672923  -6.97760446834849
2 2.53553655796277  -9.08992515687905
4
2 15.77404745214733  354.34497726963627
4 4.73151965524271  -3.36287649403606
2 6.42239944060001  14.71521955511648
2 2.32994046862664  13.55892748683944
4
2 7.33144203381817  292.77154646752041
4 6.95334051230636  -10.22940515651113
2 4.81090609552060  5.35617134736248
2 5.10262053551315  9.36573321592415
4
2 4.74995250742888  115.85664824979435
4 6.57684511405943  -0.64293530019863
2 9.87507257924310  5.36997846374246
2 6.28679531544155  12.55040524234823
2
2 1.80236598276304  13.58753422933148
2 3.31611398309890  12.94363478130705
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-56.79506756
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
    H 0.0 0.0 1.20
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


table,1.20,scf,ccsd,bind
save
type,csv


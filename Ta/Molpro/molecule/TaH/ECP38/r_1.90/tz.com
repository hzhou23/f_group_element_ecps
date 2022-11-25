***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 8.39839546163777 , 13.0
3, 7.35115489540652 , 109.179141001291010
2, 3.58124428760265 , -6.97580462770369
2, 2.45026266325000 , -9.09318487919907
4
2, 15.76568613335304,  354.34516920116397
4, 4.73325990664599 , -3.36105664802150
2, 6.40762966562004 , 14.71817077051004
2, 2.32637448385383 , 13.56883491973857
4
2, 7.42086531228721 , 292.77094162266002
4, 6.95098684482897 , -10.22978033865548
2, 4.81907971693152 , 5.35369490265210
2, 5.11425064145779 , 9.36367585503029
4
2, 4.75911043201779 , 115.85654187711540
4, 6.57682468475884 , -0.64309821397605
2, 9.87509512090439 , 5.36999835335242
2, 6.28718844510780 , 12.55034798564374
2
2, 1.79845473962337 , 13.58770776362467
2, 3.31578519140372 , 12.94365904773318
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.29555056
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
    H 0.0 0.0 1.90
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


table,1.90,scf,ccsd,bind
save
type,csv


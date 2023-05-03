***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Lu, 60, 3 ;
4
1, 10.52837009007923,   11.0
3, 14.86622019153146,   115.812070990871530
2, 3.57977634311843 ,  -5.91996927484231
2, 1.78997484335725 ,  -4.23944565411987
2
2, 9.18114233358304 , 140.81336396399612
2, 2.29158165834788 ,  12.43787401362676
2
2, 8.76684999069183 ,  81.54543982661006
2, 2.21732998124290 ,  14.80388049462967
2
2, 4.16519143103712 ,  55.15807001958618
2, 3.33912075809821 ,  7.35466638514045
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/messyminus.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Lu_ccsd=-40.33772772
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 12
symm = 1
ss= 0

!There are irrep cards paramters
A1=4
B1=1
B2=1
A2=0


geometry={
    2
    LuH molecule
    Lu 0.0 0.0 0.0
    H 0.0 0.0 2.00
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Lu_ccsd-H_ccsd


table,2.00,scf,ccsd,bind
save
type,csv


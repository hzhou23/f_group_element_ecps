***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, rh, 28, 3
4
1, 24.39418339667943,  17.0
3, 22.04039328647782,  414.701117743550310
2, 8.68959802091859 , -11.28596716898800
2, 9.42876174408168 , -13.65967314795482
2
2, 12.14222075163778,  246.88885026177641
2, 5.27587258937924 , 32.47728600373158
2
2, 9.30893198370713 , 181.20541890285168
2, 7.08173403078745 , 29.20305213092277
2
2, 9.04660426307257 , 83.08287561534985
2, 3.77483713896007 , 10.89084468142145
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Rh-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Rh_ccsd=-110.00027233
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 18
symm = 1
ss= 2

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    RhH molecule
    Rh 0.0 0.0 0.0
    H 0.0 0.0 1.90
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy
bind=ccsd-Rh_ccsd-H_ccsd


table,1.90,scf,ccsd,bind
save
type,csv


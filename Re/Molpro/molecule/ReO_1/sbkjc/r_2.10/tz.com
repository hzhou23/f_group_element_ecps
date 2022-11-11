***,Calculation for Re atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
1; !  ul potential
1,2.5173100,-6.6222500;
3; !  s-ul potential
0,1.0060300,3.3206700;
2,2.5206500,-39.9186000;
2,3.8655000,101.8323600;
3; !  p-ul potential
0,1.2288400,3.8373500;
2,2.6503300,-121.9941600;
2,3.0168600,166.1714400;
2; !  d-ul potential
0,29.2349900,4.5781900;
2,3.8642200,58.7277600;
1; !  f-ul potential
0,1.2745600,6.4431500;
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Re_ccsd=-78.59522714
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 21
symm = 1
ss= 1

!There are irrep cards paramters
A1=6
B1=2
B2=2
A2=1


geometry={
    2
    ReO molecule
    Re 0.0 0.0 0.0
    O 0.0 0.0 2.10
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Re_ccsd-O_ccsd


table,2.10,scf,ccsd,bind
save
type,csv


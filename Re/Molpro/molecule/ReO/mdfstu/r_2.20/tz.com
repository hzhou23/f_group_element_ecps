***,Calculation for Re atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,Re,60,5,0;
1; 2,1.000000,0.000000; 
2; 2,12.163814,421.970300; 2,7.107595,50.134439; 
4; 2,9.684597,88.481910; 2,9.476214,176.787220; 2,7.668066,10.434338; 2,5.055156,20.458743; 
4; 2,6.509888,43.162431; 2,6.091216,64.767759; 2,4.164006,5.340301; 2,4.407379,8.243332; 
2; 2,2.562658,7.244543; 2,2.521549,9.659266; 
2; 2,4.034599,-7.974940; 2,4.009628,-9.882736; 
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


Re_ccsd=-78.31787943
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 21
symm = 1
ss= 5

!There are irrep cards paramters
A1=6
B1=3
B2=3
A2=1


geometry={
    2
    ReO molecule
    Re 0.0 0.0 0.0
    O 0.0 0.0 2.20
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Re_ccsd-O_ccsd


table,2.20,scf,ccsd,bind
save
type,csv


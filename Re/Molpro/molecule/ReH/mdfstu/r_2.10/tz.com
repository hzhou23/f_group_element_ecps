***,Calculation for Y atom, singlet and triplet
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
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Re_ccsd=-78.31787943
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 16
symm = 1
ss= 4

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    ReH molecule
    Re 0.0 0.0 0.0
    H 0.0 0.0 2.10
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
bind=ccsd-Re_ccsd-H_ccsd


table,2.10,scf,ccsd,bind
save
type,csv


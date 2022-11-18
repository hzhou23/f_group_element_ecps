***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 11.88350471855019,  13.0
3, 10.97377991301274,  154.485561341152470
2, 2.01971647266911 , -1.13189017422195
2, 2.69767939922724 , -1.45042145161090
2
2, 16.54628001682965,  459.65608518058320
2, 3.87872556430454 , 24.60162382163432
2
2, 11.22461418294209,  378.65585022268527
2, 4.14425727614165 , 26.75998268495469
2
2, 5.96253273825446 , 106.73173866394947
2, 4.42656456365080 , 23.03770926634766
2
2, 2.87921258907750 , 12.36300003963198
2, 1.86942107458829 , 12.21690623386405
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


Ta_ccsd=-56.70181713
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 19
symm = 1
ss= 3

!There are irrep cards paramters
A1=4
B1=3
B2=3
A2=1


geometry={
    2
    TaH molecule
    Ta 0.0 0.0 0.0
    O 0.0 0.0 2.10
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2-1,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Ta_ccsd-O_ccsd


table,2.10,scf,ccsd,bind
save
type,csv


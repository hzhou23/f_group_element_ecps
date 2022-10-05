***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,Zr,28,3
4
1, 17.03262139524113,  12.0
3, 15.12020744616823,  204.391456742893560
2, 4.61206060054483 , -13.98855964518640
2, 14.81325640713171,  -10.32780428424636
2
2, 8.91459645055086 , 150.11475541017958
2, 3.84749176687513 , 29.40467073765581
2
2, 7.51893648454902 , 99.43824148554556
2, 3.72498603422784 , 25.21973464940891
2
2, 2.14420155075322 , 4.71600951644665
2, 5.19913196126536 , 46.31496930149645
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Zr-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 13
symm = 2
ss= 1

!There are irrep cards paramters
A1=4
B1=2
B2=1
A2=0


geometry={
    2
    YH molecule
    Zr 0.0 0.0 0.0
    H 0.0 0.0 1.80
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1-1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t),shifts=0.5,shiftp=0.5,thrdis=1.0;diis,1,1,15,1;maxit,200;core}
ccsd=energy



geometry={
    1
    Zr atom
    Zr 0.0 0.0 0.0
}
{rhf
 start,atden
 print,orbitals=2
 wf,12,1,2
 occ,4,1,1,0,1,0,0,0
 closed,2,1,1,0,1,0,0,0
 sym,1,1,1,3,2
 orbital,4202.2
}
pop
{multi
 start,4202.2
 occ,4,1,1,1,1,1,1,0
 closed,2,1,1,0,1,0,0,0
 wf,12,1,2;state,1
 wf,12,4,2;state,3
 wf,12,6,2;state,3
 wf,12,7,2;state,3
 natorb,ci,print
 orbital,5202.2
}
{rhf,nitord=1,maxit=0
 start,5202.2
 wf,12,1,2
 occ,4,1,1,0,1,0,0,0
 closed,2,1,1,0,1,0,0,0
 sym,1,1,1,3,2
}
Zr_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,200;core}
Zr_ccsd=energy



bind=ccsd-Zr_ccsd-H_ccsd


table,1.80,scf,ccsd,bind
save
type,csv


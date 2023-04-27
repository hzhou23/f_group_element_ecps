***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, Lu, 60, 3 ;
4
1, 11.96898756632240,   11.0
3, 11.18772892813810,   131.658863229546400
2, 3.99502348829345 ,  -6.34682191614121
2, 2.25379129582714 ,  -6.65092196991013
2,
2, 8.31745285402191 , 141.28341711365573
2, 3.01451808680734 ,  14.11796955623288
2,
2, 6.37036719972606 ,  81.22243719609351
2, 3.29515002182652 ,  15.06103939469560
2,
2, 5.03083846925270 ,  55.23609244784316
2, 2.55964060371634 ,  4.98086991821593
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/messyminus.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Lu_ccsd=-41.82487761
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 17
symm = 1
ss= 1

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=0


geometry={
    2
    LuO molecule
    Lu 0.0 0.0 0.0
    O 0.0 0.0 length
}
{rhf,nitord=60;
 start,atden
 maxit,200;
 wf,ne-1,symm,ss-1
 occ,A1-1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
 orbital,2202.2
}
{rhf,nitord=60;
 start,2202.2
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-1,B1,B2,A2
 print,orbitals=2
 orbital,3202.2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Lu_ccsd-O_ccsd


table,length,scf,ccsd,bind
save
type,csv


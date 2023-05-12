***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,Lu,60,3;
4
1, 11.57946201357549,   11.0
3, 15.86580272590387,   127.374082149330390
2, 2.53570742282506 ,  -7.23563937562117
2, 1.46782645918870 ,  -4.59730504398968
2
2, 8.38401558769781 , 142.10178857939442
2, 1.67207804367328 ,  10.50332929060090
2
2, 6.91954430650362 ,  81.61565276672526
2, 1.62499413814527 ,  10.78057305736433
2
2, 3.64765389309640 ,  57.96875414975823
2, 2.52869062078326 ,  5.90711409842941
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


Lu_ccsd=-40.46048677
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
    O 0.0 0.0 1.10
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


table,1.10,scf,ccsd,bind
save
type,csv


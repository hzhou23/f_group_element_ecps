***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,Lu,60,4,0;
1; 2,1.000000,0.000000; 
2; 2,7.631500,299.806838; 2,3.815700,-2.015183; 
2; 2,6.546300,177.414461; 2,3.273100,0.695491; 
2; 2,4.459700,59.213397; 2,2.229800,-0.184093; 
1; 2,1.603000,8.264490;
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


Lu_ccsd=-38.01058529
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


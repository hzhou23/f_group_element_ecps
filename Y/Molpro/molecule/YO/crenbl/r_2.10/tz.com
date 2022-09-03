***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-12


basis={
ECP, y, 28, 3 ;
5;
2,2.90050006,-2.22248793;
2,7.94630003,-23.57674599;
2,21.59399986,-59.28044128;
2,78.34619904,-164.74046326;
1,265.06298828,-22.87406540;
7;
2,2.68510008,55.64851379;
2,3.13739991,-177.82318115;
2,4.20650005,354.56311035;
2,6.10620022,-340.00125122;
2,8.79300022,239.03950500;
1,26.35610008,14.65989113;
0,26.61560059,3.39070010;
7;
2,2.37949991,50.28510666;
2,2.77360010,-160.27282715;
2,3.70539999,317.67678833;
2,5.37099981,-336.20748901;
2,7.78319979,237.31672668;
1,22.16099930,12.75121307;
0,20.47360039,5.37008190;
7;
2,1.58969998,33.29671097;
2,1.85490000,-109.96274567;
2,2.44250011,213.90904236;
2,3.47909999,-273.61801147;
2,4.95599985,207.30749512;
1,15.23060036,10.78762054;
0,13.37300015,7.32198191;
ecp,O,2,1,0
3
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1
2,  13.65512,  85.86406
include,../../generate/Y-aug-cc-pwCVTZ.basis
include,../../generate/O-aug-cc-pwCVTZ.basis
}


Y_ccsd=-38.10393007
O_ccsd=-15.85572648

!These are the wf cards parameters
ne = 17
symm = 1
ss=1

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=0


geometry={
    2
    YO molecule
    Y 0.0 0.0 0.0
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
bind=ccsd-Y_ccsd-O_ccsd


table,2.10,scf,ccsd,bind
save
type,csv


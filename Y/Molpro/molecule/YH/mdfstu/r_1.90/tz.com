***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-12


basis={
ECP,Y,28,4,3;
1; 2,1.000000,0.000000; 
2; 2,7.858275,135.134974; 2,3.382128,15.411632; 
4; 2,6.849791,29.251437; 2,6.710092,58.508363; 2,3.042159,3.780243; 2,2.937330,7.676547; 
4; 2,5.416315,11.849911; 2,5.333416,17.778103; 2,1.976212,2.062383; 2,1.961111,3.075654; 
2; 2,5.028590,-6.928078; 2,5.005582,-9.155099; 
4; 2,6.849791,-58.502875; 2,6.710092,58.508363; 2,3.042159,-7.560487; 2,2.937330,7.676547; 
4; 2,5.416315,-11.849911; 2,5.333416,11.852069; 2,1.976212,-2.062383; 2,1.961111,2.050436; 
2; 2,5.028590,4.618718; 2,5.005582,-4.577550;
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/Y-aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Y_ccsd=-38.05746025
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 12
symm = 1
ss= 0

!There are irrep cards paramters
A1=4
B1=1
B2=1
A2=0


geometry={
    2
    YH molecule
    Y 0.0 0.0 0.0
    H 0.0 0.0 1.90
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Y_ccsd-H_ccsd


table,1.90,scf,ccsd,bind
save
type,csv


***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP,Zr,28,3
4
1, 16.88916955214899,  12.0
3, 15.70155920049030,  202.670034625787880
2, 5.27034346026929 , -13.60436651220228
2, 14.80184984865866,  -10.18218619267969
2
2, 8.92572642375107 , 150.10129854615641
2, 4.00471169745348 , 29.39484690445374
2
2, 7.61528131494023 , 99.47278722552167
2, 3.85232509119085 , 25.32204110021444
2
2, 2.25617497504952 , 4.80354594039894
2, 5.30913761102471 , 46.64025520338745
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


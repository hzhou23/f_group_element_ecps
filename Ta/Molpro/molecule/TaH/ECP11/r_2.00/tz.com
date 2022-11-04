***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 9.48388478772007 , 13.0
3, 6.69395502611293 , 123.290502240360910
2, 3.84564846737412 , -4.83060140428166
2, 4.74329792329606 , -7.56623967331896
4
2, 12.08070487785103,  254.45008494340559
4, 5.25937380175783 , 3.13331584243314
2, 2.86496852384317 , -2.52182496924177
2, 4.95043584883815 , 14.19625032387860
4
2, 10.48690162330973,  292.80916800034873
4, 8.92737654563204 , 11.08122839018250
2, 5.12940271945628 , -1.90960957735751
2, 5.29711641515450 , 12.13177510299480
4
2, 6.47931667618884 , 115.54885178432272
4, 5.88342252261920 , 1.25606362129650
2, 1.44034665441339 , -0.59901339889801
2, 4.49651531729617 , 12.46122741500653
2
2, 4.31516890661817 , 13.45463417774284
2, 2.51136393398202 , 12.99026601442901
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.51534921
H_ccsd=-0.49982987

!These are the wf cards parameters
ne = 14
symm = 1
ss= 4

!There are irrep cards paramters
A1=4
B1=2
B2=2
A2=1


geometry={
    2
    TaH molecule
    Ta 0.0 0.0 0.0
    H 0.0 0.0 2.00
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
bind=ccsd-Ta_ccsd-H_ccsd


table,2.00,scf,ccsd,bind
save
type,csv


***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 8.39619309140809 , 13.0
3, 7.36992397024221 , 109.150510188305170
2, 3.59518841220200 , -6.97726518693205
2, 2.53677260839851 , -9.08942389585096
4
2, 15.79093928474706,  354.34498288558484
4, 4.73173025972451 , -3.36276669765253
2, 6.42174108122632 , 14.71532838566159
2, 2.32252805796118 , 13.55978504848528
4
2, 7.34663031495202 , 292.77156028201830
4, 6.95339444124924 , -10.22939642278778
2, 4.81071656533567 , 5.35622798324612
2, 5.10235013514467 , 9.36578075512708
4
2, 4.75655342485759 , 115.85657007036401
4, 6.57683874163726 , -0.64295148548811
2, 9.87508313993774 , 5.36997400882924
2, 6.28701260750721 , 12.55037723846012
2
2, 1.80236295877641 , 13.58753436362208
2, 3.31611372941656 , 12.94363480028320
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-56.80278959
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
    H 0.0 0.0 2.40
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


table,2.40,scf,ccsd,bind
save
type,csv


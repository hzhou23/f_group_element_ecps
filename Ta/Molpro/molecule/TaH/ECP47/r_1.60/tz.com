***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
4
1, 6.58579803212618 , 13.0
3, 9.13192842576420 , 85.615374417640340
2, 7.99186085237527 , -0.26293749961227
2, 1.84263860654940 , -2.27391351331509
4
2, 16.08487737880344,  354.56078018080508
4, 4.85668884301541 , -3.18906211229170
2, 6.30802922975839 , 15.43406034238401
2, 4.04911757928159 , 17.92189033024011
4
2, 9.21923589281251 , 291.70871884263369
4, 8.30422516651248 , -10.54318109647359
2, 3.16045125855980 , -0.60632678182044
2, 2.27620720575355 , 3.70756033781846
4
2, 5.66393146919502 , 119.43407155054338
4, 6.80490694652875 , -1.42875323933968
2, 5.86746551190718 , 6.08463244531056
2, 5.45850446761400 , 14.58929295482653
2
2, 1.88569677412283 , 13.74156012098197
2, 3.23123426818858 , 12.9670388260891
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ;
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
include,../../generate/aug-cc-pwCVTZ.basis
include,../../generate/H-aug-cc-pVTZ.basis
}


Ta_ccsd=-57.26121891
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
    H 0.0 0.0 1.60
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


table,1.60,scf,ccsd,bind
save
type,csv


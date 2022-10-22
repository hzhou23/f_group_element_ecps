***,Calculation for Y atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, ta, 60, 4 ;
6; !  ul potential
2,0.97380000,-0.45041099;
2,2.72210002,-7.63836813;
2,7.14249992,-43.87855530;
2,18.33259964,-97.77507019;
2,63.04660034,-287.56149292;
1,201.99899292,-46.50049973;
8; !  s-ul potential
2,2.10870004,-40.60095978;
2,2.46819997,126.83788300;
2,3.29310012,-235.24430847;
2,4.87939978,445.97167969;
2,7.62050009,-389.18530273;
2,12.02050018,355.67025757;
1,35.52090073,28.51909828;
0,30.82360077,6.77081203;
8; !  p-ul potential
2,0.57340002,-0.09473200;
2,2.51550007,59.86339188;
2,3.03670001,-192.32298279;
2,4.18940020,388.45581055;
2,6.30660009,-359.23678589;
2,9.71700001,300.74194336;
1,25.63400078,34.81594086;
0,34.21419907,5.73217821;
8; !  d-ul potential
2,0.37210000,-0.03177600;
2,1.78380001,37.44372940;
2,2.09549999,-120.92505646;
2,2.76589990,226.60716248;
2,3.95749998,-243.61962891;
2,5.68820000,210.83656311;
1,15.65960026,53.84714890;
0,43.08679962,6.98262882;
8; !  f-ul potential
2,0.76929998,26.30927849;
2,0.85350001,-63.06319427;
2,1.00039995,55.48675537;
2,1.13390005,-12.49588585;
2,3.51349998,24.29885674;
2,10.11849976,89.15798187;
1,26.51479912,32.28345489;
0,58.97980118,1.07911205;
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


Ta_ccsd=-57.48166149
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 19
symm = 1
ss= 1

!There are irrep cards paramters
A1=5
B1=2
B2=2
A2=1


geometry={
    2
    TaH molecule
    Ta 0.0 0.0 0.0
    O 0.0 0.0 2.20
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
bind=ccsd-Ta_ccsd-O_ccsd


table,2.20,scf,ccsd,bind
save
type,csv


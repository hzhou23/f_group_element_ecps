***,Calculation for Re atom, singlet and triplet
memory,1,g

gthresh,twoint=1.0E-15
gthresh,throvl=1.0E-15


basis={
ECP, re, 60, 4 ;
6; !  ul potential
2,1.34420002,-0.63006300;
2,3.63630009,-10.51489067;
2,9.45650005,-58.95209122;
2,25.35820007,-115.01941681;
2,83.40769959,-347.15853882;
1,276.78070068,-49.26778412;
8; !  s-ul potential
2,2.36209989,-44.26672363;
2,2.72939992,129.19606018;
2,3.67540002,-242.92758179;
2,5.53210020,501.74584961;
2,8.98340034,-445.97048950;
2,15.25590038,394.00692749;
1,50.81330109,26.49606895;
0,35.46549988,6.66976500;
8; !  p-ul potential
2,2.03469992,-40.03034592;
2,2.35809994,126.64355469;
2,3.05710006,-228.62715149;
2,4.39909983,402.92218018;
2,6.61850023,-364.56909180;
2,10.01210022,314.11911011;
1,25.28219986,41.13771057;
0,38.69940186,5.77764893;
8; !  d-ul potential
2,1.33980000,-19.84150887;
2,1.50170004,41.82987595;
2,2.26449990,-115.67475128;
2,3.06690001,256.13897705;
2,4.50220013,-264.05648804;
2,6.76459980,231.04666138;
1,15.22159958,28.69319344;
0,21.53820038,7.87635279;
8; !  f-ul potential
2,1.48140001,-69.01650238;
2,1.68589997,172.23371887;
2,2.11229992,-173.36340332;
2,2.64039993,97.75544739;
2,9.64130020,78.55423737;
2,24.78100014,126.52191925;
1,57.28340149,37.84556961;
0,142.22329712,0.79649299;
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


Re_ccsd=-78.67385466
O_ccsd=-15.86622096

!These are the wf cards parameters
ne = 21
symm = 1
ss= 5

!There are irrep cards paramters
A1=6
B1=3
B2=3
A2=1


geometry={
    2
    ReO molecule
    Re 0.0 0.0 0.0
    O 0.0 0.0 2.10
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
 occ,A1,B1,B2,A2
 closed,A1-2,B1-1,B2-1,A2-1
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Re_ccsd-O_ccsd


table,2.10,scf,ccsd,bind
save
type,csv

